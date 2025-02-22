// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:msdl/commons/widgets/buttons/customButton.dart';
import 'package:msdl/constants/gaps.dart';
import 'package:msdl/constants/size_config.dart';
import 'package:msdl/constants/sizes.dart';
import 'package:msdl/features/screens/workplace/widget/DraggableBottomSheet.dart'
    as bottom;
import 'package:msdl/features/screens/workplace/widget/boxInBottomBar.dart';

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
  double _floatingButtonOffset = 100;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMapStyle();

    _sheetController.addListener(() {
      setState(() {
        _floatingButtonOffset = 200 + (_sheetController.size - 0.28) * 600;
      });
    });
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

  Future<void> _goToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    maps.LatLng newPosition =
        maps.LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = newPosition;
    });

    _mapController.animateCamera(maps.CameraUpdate.newLatLng(newPosition));
    _updateAddress(newPosition);
  }

  void _onMapCreated(maps.GoogleMapController controller) {
    _mapController = controller;
    if (_darkMapStyle != null) {
      _mapController.setMapStyle(_darkMapStyle);
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
              zoomControlsEnabled: false,
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
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/homeScreen");
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFFAAAAAA),
              ),
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

          Positioned(
            bottom: _floatingButtonOffset,
            right: 5,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: Icon(
                Icons.my_location_rounded,
                color: Colors.red,
              ),
              onPressed: _goToCurrentLocation,
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
                      SizedBox(height: 10.h),
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
