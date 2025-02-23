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
import 'package:msdl/features/screens/workplace/widget/DraggableBottomSheet.dart';

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
      if (!mounted) return;
      setState(() {
        _floatingButtonOffset = 200 + (_sheetController.size - 0.28) * 600;
      });
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 꺼져 있는 경우
      return Future.error('Location services are disabled.');
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 사용자가 권한을 거부한 경우
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 사용자가 "다시 묻지 않음"을 선택한 경우
      return Future.error('Location permissions are permanently denied.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!mounted) return;

    setState(() {
      _currentPosition = maps.LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _updateAddress(maps.LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String buildingName = placemarks[0].name ?? "";
        String streetName = placemarks[0].street ?? "";
        String locality = placemarks[0].locality ?? "";
        String country = placemarks[0].country ?? "";

        if (!mounted) return;

        setState(() {
          _currentAddress = buildingName.isNotEmpty ? buildingName : streetName;
          if (locality.isNotEmpty) _currentAddress += ", $locality";
          if (country.isNotEmpty) _currentAddress += ", $country";
        });
      }
    } catch (e) {
      if (!mounted) return;
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

    if (!mounted) return;

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
    var children = [
      GestureDetector(
        onTap: () {
          _sheetController.animateTo(0.12,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        child: maps.GoogleMap(
          initialCameraPosition: maps.CameraPosition(
            target: _currentPosition,
            zoom: 14.0,
          ),
          onMapCreated: _onMapCreated,
          zoomControlsEnabled: false,
          onCameraMove: (maps.CameraPosition position) {
            if (!mounted) return;
            setState(() {
              _markerYOffset = -10;
              _currentPosition = position.target;
            });
          },
          onCameraIdle: () {
            if (!mounted) return;
            setState(() {
              _markerYOffset = 0;
            });
            _updateAddress(_currentPosition);
          },
        ),
      ),

      Positioned(
        top: Sizes.size40,
        left: Sizes.size20,
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
        right: Sizes.size5,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          onPressed: _goToCurrentLocation,
          highlightElevation: 0,
          splashColor: Colors.transparent,
          hoverElevation: 0,
          child: Icon(
            Icons.my_location_rounded,
            color: Color(0xFFEB3223),
          ),
        ),
      ),

      // 하단 현재 위치 정보 패널
      DraggleSheet(
        sheetController: _sheetController,
        currentAddress: _currentAddress,
      ),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: children,
      ),
    );
  }
}
