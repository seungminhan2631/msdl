import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;

class WorkplaceScreen extends StatefulWidget {
  const WorkplaceScreen({super.key});

  @override
  State<WorkplaceScreen> createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(37.5665, 126.9780); // 기본 위치 (서울)

  // 마커 이미지 변수 (nullable 처리)
  BitmapDescriptor? _markerStatic;
  BitmapDescriptor? _markerMoving;
  bool _isMoving = false; // 카메라 이동 상태 변수

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadCustomMarkers(); // 마커 이미지 로드
  }

  // 마커 이미지 불러오기 (예외 방지)
  Future<void> _loadCustomMarkers() async {
    try {
      final staticMarker = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/images/박보영.jpg');

      final movingMarker = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(48, 48)),
          'assets/images/한승민.png');

      if (mounted) {
        setState(() {
          _markerStatic = staticMarker;
          _markerMoving = movingMarker;
        });
      }
    } catch (e) {
      print("마커 로드 오류: $e");
    }
  }

  // 위치 권한 확인 및 현재 위치 가져오기
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 서비스가 비활성화됨");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("위치 권한이 거부됨");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("위치 권한이 영구적으로 거부됨");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (mounted) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    }

    mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  // 카메라 이동 이벤트 추가
  void _onCameraMove(CameraPosition position) {
    if (mounted) {
      setState(() {
        _isMoving = true;
      });
    }
  }

  // 카메라 이동 종료 이벤트 추가
  void _onCameraIdle() {
    if (mounted) {
      setState(() {
        _isMoving = false;
      });
    }
  }

  // 지도 초기화
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Google Maps Workplace")),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 15.0,
          ),
          myLocationEnabled: false, // 기본 현재 위치 아이콘 숨김 (커스텀 마커 사용)
          myLocationButtonEnabled: true,
          onCameraMove: _onCameraMove, // 카메라 이동 이벤트 추가
          onCameraIdle: _onCameraIdle, // 카메라 멈춤 이벤트 추가
          markers: {
            Marker(
              markerId: const MarkerId("current_location"),
              position: _currentPosition,
              icon: (_isMoving ? _markerMoving : _markerStatic) ??
                  BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: "현재 위치"),
            ),
          },
        ),
      ),
    );
  }
}
