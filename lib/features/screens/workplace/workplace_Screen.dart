import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:msdl/constants/size_config.dart';

class WorkplaceScreen extends StatefulWidget {
  @override
  _WorkplaceScreenState createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  late maps.GoogleMapController _mapController;

  // 초기 지도 위치 (순천향대학교)
  maps.LatLng _currentPosition = maps.LatLng(36.7667, 126.9322);

  // 현재 주소 저장
  String _currentAddress = "위치를 불러오는 중...";

  // 마커 애니메이션을 위한 Y축 오프셋 값
  double _markerYOffset = 0;

  // 다크 모드 지도 스타일 JSON 저장
  String? _darkMapStyle;

  @override
  void initState() {
    super.initState();
    _determinePosition(); // 앱 실행 시 현재 위치 가져오기
    _loadMapStyle(); // 다크 모드 스타일 로드
  }

  // 📌 다크 모드 스타일 JSON 로드
  Future<void> _loadMapStyle() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  // 📌 사용자의 현재 위치 가져오는 함수
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    maps.LatLng newPosition =
        maps.LatLng(position.latitude, position.longitude);

    // 현재 위치 업데이트
    setState(() {
      _currentPosition = newPosition;
    });

    // 주소 업데이트
    _updateAddress(newPosition);

    // 카메라 이동 (현재 위치로)
    _mapController.animateCamera(maps.CameraUpdate.newLatLng(newPosition));
  }

  // 📌 현재 위치의 주소를 변환하는 함수
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

  // 📌 Google Map 생성 시 호출되는 함수 (다크 모드 적용)
  void _onMapCreated(maps.GoogleMapController controller) {
    _mapController = controller;
    if (_darkMapStyle != null) {
      _mapController.setMapStyle(_darkMapStyle); // 📍 다크 모드 적용
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📌 Google 지도 (다크 모드 적용됨)
          maps.GoogleMap(
            initialCameraPosition: maps.CameraPosition(
              target: _currentPosition,
              zoom: 14.0,
            ),
            onMapCreated: _onMapCreated, // 다크 모드 적용
            onCameraMove: (maps.CameraPosition position) {
              setState(() {
                _markerYOffset = -10; // 마커를 살짝 위로 올리는 효과
                _currentPosition = position.target; // 📍 카메라 이동 중 위치 실시간 반영
              });
            },
            onCameraIdle: () {
              setState(() {
                _markerYOffset = 0; // 마커 원래 위치로 복귀
              });
              _updateAddress(_currentPosition); // 📍 최종 위치의 주소 업데이트
            },
          ),

          // 📌 중앙 마커 (애니메이션 적용)
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

          // 📌 하단 현재 위치 정보 패널
          DraggableScrollableSheet(
            initialChildSize: 0.12,
            minChildSize: 0.05,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF2C2C2C),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFCACACA),
                      width: 2.0.w,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 손잡이
                    Container(
                      width: 80,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                      "Current location : ",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontFamily: "Andika",
                      ),
                    ),
                    // 실시간 주소 업데이트
                    Text(
                      _currentAddress,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
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
