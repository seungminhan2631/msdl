import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/constants/size_config.dart';

class WorkplaceScreen extends StatefulWidget {
  @override
  _WorkplaceScreenState createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  late maps.GoogleMapController _mapController;
  DraggableScrollableController _sheetController =
      DraggableScrollableController();
  maps.LatLng _currentPosition = maps.LatLng(36.7667, 126.9322);
  String _currentAddress = "Loading location...";
  double _markerYOffset = 0;
  String? _darkMapStyle;
  TextEditingController _searchController = TextEditingController();
  final _placesSdk = places.FlutterGooglePlacesSdk(
      "AIzaSyDqkZIaLDnIydApRd_OMUsnHDeiOMm8pr4"); // API 키 입력
  List<places.AutocompletePrediction> _predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMapStyle();
  }

  @override
  void dispose() {
    _debounce?.cancel(); // 🛑 타이머 해제 추가
    super.dispose();
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    maps.LatLng newPosition =
        maps.LatLng(position.latitude, position.longitude);
    setState(() {
      _currentPosition = newPosition;
    });
    _updateAddress(newPosition);
    _mapController.animateCamera(maps.CameraUpdate.newLatLng(newPosition));
  }

  Future<void> _updateAddress(maps.LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _currentAddress =
              "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "주소를 찾을 수 없음";
      });
    }
  }

  void _onMapCreated(maps.GoogleMapController controller) {
    _mapController = controller;
    if (_darkMapStyle != null) {
      _mapController.setMapStyle(_darkMapStyle);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // 디바운싱 적용
    _debounce = Timer(Duration(milliseconds: 500), () {
      _searchPlaces(query);
    });
  }

  // 검색 기능 추가 (Google Places API 활용)
  void _searchPlaces(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final result = await _placesSdk.findAutocompletePredictions(query);
      if (!mounted) return; // State 해제 확인 추가
      setState(() {
        _predictions = result.predictions;
      });
    } catch (e, stacktrace) {
      print("검색 오류 발생: $e");
      print(stacktrace);
      if (!mounted) return;
      setState(() {
        _predictions = [];
      });
    }
  }

  void _moveToSearchedLocation(String placeName) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        maps.LatLng newPosition =
            maps.LatLng(locations.first.latitude, locations.first.longitude);
        _mapController.animateCamera(maps.CameraUpdate.newLatLng(newPosition));
        setState(() {
          _currentPosition = newPosition;
          _currentAddress = placeName;
          _predictions.clear(); // 선택 후 리스트 비우기
        });
      }
    } catch (e) {
      print("주소 이동 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _sheetController.animateTo(0.12,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: maps.GoogleMap(
              initialCameraPosition: maps.CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              onMapCreated: _onMapCreated,
              onCameraMove: (maps.CameraPosition position) {
                setState(() {
                  _markerYOffset = -10;
                  _currentPosition = position.target;
                });
              },
              onCameraIdle: () {
                setState(() {
                  _markerYOffset = 0;
                });
                _updateAddress(_currentPosition);
              },
            ),
          ),

          Positioned(
            top: 40,
            left: 10,
            right: 20,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/homeScreen");
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF2C2C2C).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.red),
                    ),
                    child: TextField(
                      cursorColor: Color(0xFFAAAAAA),
                      controller: _searchController,
                      onChanged: _searchPlaces,
                      decoration: InputDecoration(
                        hintText: "Search location",
                        hintStyle: TextStyle(
                          fontFamily: "Andika",
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                        prefixIcon:
                            Icon(Icons.search_rounded, color: Colors.red),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),

                // 검색 결과 리스트 (자동완성 최대 2개만 표시)
                if (_predictions.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2C2C2C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          _predictions.length > 2 ? 2 : _predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_predictions[index].fullText),
                          onTap: () {
                            _searchController.text =
                                _predictions[index].fullText;
                            _moveToSearchedLocation(
                                _predictions[index].fullText);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 중앙 마커
          Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.translationValues(0, _markerYOffset, 0),
              child: Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.red,
              ),
            ),
          ),

          // 하단 현재 위치 정보 패널
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.12,
            minChildSize: 0.05,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFCACACA),
                      width: 1.0.w,
                    ),
                  ),
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Current location : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Andika",
                        ),
                      ),
                      Text(
                        _currentAddress,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Andika",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BoxInBottomBar(
                            text: "Lab",
                            icon: Icons.science_outlined,
                            iconColor: Color(0xFFFFB400),
                          ),
                          _BoxInBottomBar(
                            text: "Home",
                            icon: Icons.home_work_outlined,
                            iconColor: Color(0xFF3F51B5),
                          ),
                          _BoxInBottomBar(
                            text: "Out Of Office (OOO)",
                            icon: Icons.business_center_outlined,
                            iconColor: Color(0xFF935E38),
                          ),
                          _BoxInBottomBar(
                            text: "Other",
                            icon: Icons.more_horiz_outlined,
                            iconColor: Color(0xFF151515),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomButton(
                        text: "Add New Workplace",
                        routeName: "/homeScreen",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BoxInBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const _BoxInBottomBar({
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 100.h,
      decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFFAAAAAA), width: 1.w)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: iconColor),
        const SizedBox(height: 5),
        Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "Andika",
                fontWeight: FontWeight.w700,
                fontSize: 15))
      ]),
    );
  }
}
