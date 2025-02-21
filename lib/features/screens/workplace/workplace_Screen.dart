import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;

class WorkplaceScreen extends StatefulWidget {
  @override
  _WorkplaceScreenState createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  late maps.GoogleMapController _mapController;
  maps.LatLng _currentPosition = maps.LatLng(36.7667, 126.9322);
  String _currentAddress = "Loading location...";
  double _markerYOffset = 0;
  String? _darkMapStyle;
  TextEditingController _searchController = TextEditingController();
  final _placesSdk = places.FlutterGooglePlacesSdk(
      "AIzaSyDqkZIaLDnIydApRd_OMUsnHDeiOMm8pr4"); // API 키 입력
  List<places.AutocompletePrediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMapStyle();
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

  // 검색 기능 추가 (Google Places API 활용)
  void _searchPlaces(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final result = await _placesSdk.findAutocompletePredictions(query);
      setState(() {
        _predictions = result.predictions ?? [];
      });
    } catch (e) {
      print("검색 오류 발생: $e");
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
      body: Stack(
        children: [
          maps.GoogleMap(
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

          // 검색창
          Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFFAAAAAA),
          ),
          Positioned(
            top: 40,
            left: 40,
            right: 20,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchPlaces,
                    decoration: InputDecoration(
                      hintText: "Search location",
                      hintStyle: TextStyle(
                        fontFamily: "Andika",
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                      prefixIcon:
                          Icon(Icons.search_rounded, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                          title: Text(_predictions[index].fullText ?? ""),
                          onTap: () {
                            _searchController.text =
                                _predictions[index].fullText ?? "";
                            _moveToSearchedLocation(
                                _predictions[index].fullText ?? "");
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
            initialChildSize: 0.12,
            minChildSize: 0.05,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
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
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
