import 'dart:developer';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_compass/flutter_compass.dart';

class LocationController extends GetxController {
  final location = Location();
  final Rx<LatLng> userLocation = const LatLng(-7.78294, 110.408).obs;
  final RxDouble userHeading = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initLocation();
    _initCompass();
  }

  
  void _initCompass() {
    FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        userHeading.value = event.heading!;
      }
    });
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    try {
      // 1. Cek apakah location service aktif
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          log('Location service not enabled.');
          return;
        }
      }

      // 2. Cek & request permission
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          log('Location permission not granted.');
          return;
        }
      }

      // 3. Dapatkan lokasi awal
      final currentLocation = await location.getLocation();
      log(
        'Current location: ${currentLocation.latitude}, ${currentLocation.longitude}',
      );
      _updateUserLocation(currentLocation);

      // 4. Dengarkan perubahan lokasi
      location.onLocationChanged.listen((newLocation) {
        _updateUserLocation(newLocation);
      });
    } catch (e) {
      log('Error initializing location: $e');
    }
  }

  void _updateUserLocation(LocationData data) {
    if (data.latitude != null && data.longitude != null) {
      userLocation.value = LatLng(data.latitude!, data.longitude!);
    }
    // if (data.heading != null) {
    //   userHeading.value = data.heading!;
    // }
  }
}
