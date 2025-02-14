import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WorkplaceScreen extends StatefulWidget {
  const WorkplaceScreen({super.key});

  @override
  State<WorkplaceScreen> createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  late GoogleMapController mapController; // Google Maps 컨트롤러
  LatLng _currentPosition = const LatLng(37.5665, 126.9780); // 기본 위치 (서울)

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // 현재 위치 가져오기
  }

  // 위치 권한 확인 및 현재 위치 가져오기
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1️⃣ 위치 서비스 사용 가능 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("위치 서비스가 비활성화됨");
      return;
    }

    // 2️⃣ 위치 권한 확인
    permission = await Geolocator.checkPermission();
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

    // 3️⃣ 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // 4️⃣ 현재 위치로 카메라 이동
    mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  // 지도 초기화
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getUserLocation(); // 지도 초기화 시 현재 위치 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 바탕을 터치하면 키보드 내려감
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Google Maps Workplace")),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 15.0, // 기본 줌 레벨
          ),
          myLocationEnabled: true, // 현재 위치 아이콘 표시
          myLocationButtonEnabled: true, // 현재 위치 버튼 표시
          markers: {
            Marker(
              markerId: MarkerId("current_location"),
              position: _currentPosition,
              infoWindow: InfoWindow(
                title: "현재 위치",
              ),
            ),
          },
        ),
      ),
    );
  }
}
