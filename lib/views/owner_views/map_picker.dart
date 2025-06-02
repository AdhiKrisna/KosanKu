import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/location_controller.dart';
import 'package:kosanku/controller/main_map_controller.dart';
import 'package:kosanku/controller/owner/add_kos_controller.dart';
import 'package:kosanku/controller/owner/update_kos_controller.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapPickerPage extends GetView<MainMapController> {
  MapPickerPage({super.key});
  final locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: pink,
        backgroundColor: bgBody,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: pink),
            onPressed: () {
              controller.fetchKos();
            },
          ),
        ],
        title: Text(
          'Pilih Lokasi Kos',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        final markers = <Marker>[];

        // Marker Kos dari list
        for (var kos in controller.kosList) {
          final lat = double.tryParse(kos.kosLatitude ?? '');
          final long = double.tryParse(kos.kosLongitude ?? '');
          if (lat != null && long != null) {
            if (controller.controller is UpdateKosController) {
              if (kos.id != controller.controller.currentKos.id) {
                markers.add(
                  Marker(
                    point: LatLng(lat, long),
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () => _showKosBottomSheet(context, kos),
                      child: Column(
                        children: [
                          const Icon(Icons.home, color: bgBody, size: 26),
                          Text(
                            kos.kosName ?? '',
                            style: PoppinsStyle.stylePoppins(
                              fontSize: 12,
                              color: bgBody,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              markers.add(
                Marker(
                  point: LatLng(lat, long),
                  width: 80,
                  height: 80,
                  child: GestureDetector(
                    onTap: () => _showKosBottomSheet(context, kos),
                    child: Column(
                      children: [
                        const Icon(Icons.home, color: bgBody, size: 26),
                        Text(
                          kos.kosName ?? '',
                          style: PoppinsStyle.stylePoppins(
                            fontSize: 12,
                            color: bgBody,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        }

        // Marker Lokasi User (opsional)
        if (locationController.userLocation.value.latitude != 0 &&
            locationController.userLocation.value.longitude != 0) {
          markers.add(
            Marker(
              point: locationController.userLocation.value,
              width: 80,
              height: 80,
              rotate: true,
              child: Transform.rotate(
                angle: locationController.userHeading.value * (math.pi / 180),
                child: const Icon(Icons.navigation, size: 26, color: bgBlue),
              ),
            ),
          );
        }

        // Marker Lokasi Dipilih
        markers.add(
          Marker(
            point: controller.selectedPosition.value,
            width: 60,
            height: 60,
            child: Column(
              children: [
                const Icon(Icons.home, color: Colors.green, size: 24),
                Text(
                  controller.controller.kosNameController.text.isNotEmpty
                      ? controller.controller.kosNameController.text
                      : 'Kos Ku',
                  style: PoppinsStyle.stylePoppins(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );

        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: controller.selectedPosition.value,
                initialZoom: 14,
                onTap: (_, point) {
                  controller.selectedPosition.value = point;
                  log('Selected Position: $point');
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () {
                  final position = controller.selectedPosition.value;
                  if (controller.source == 'update') {
                    final updateController =
                        controller.controller as UpdateKosController;
                    updateController.setLatLong(position);
                  } else {
                    final addController =
                        controller.controller as AddKosController;
                    addController.setLatLong(position);
                  }
                  Get.back();
                  Get.snackbar(
                    'Lokasi Terpilih',
                    'Lat: ${position.latitude}, Long: ${position.longitude}',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.check_circle, color: pink),
                label: const Text(
                  'Pilih Lokasi Ini',
                  style: TextStyle(color: pink),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgBody,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: pink,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showKosBottomSheet(BuildContext context, Kos kosan) async {
    await controller.fetchKosImageByID(kosan.id ?? 0);

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: bgBody,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: pink, width: 2),
                  borderRadius: BorderRadius.circular(15),
                  image:
                      controller.kosImageList.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(
                              controller.kosImageList.first.imageUrl ?? '',
                            ),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  kosan.kosName ?? '',
                  style: PoppinsStyle.stylePoppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: pink,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Kos ${kosan.category ?? '-'} | ',
                    style: PoppinsStyle.stylePoppins(
                      fontSize: 16,
                      color: fontBlueSky,
                    ),
                  ),
                  Text(
                    '${kosan.roomAvailable ?? '-'} Kamar Tersedia',
                    style: PoppinsStyle.stylePoppins(
                      fontSize: 16,
                      color: fontBlueSky,
                    ),
                  ),
                ],
              ),
              //min and max price
              const SizedBox(height: 8),
              Text(
                'Rp ${kosan.minPrice ?? '-'} - Rp ${kosan.maxPrice ?? '-'}',
                style: PoppinsStyle.stylePoppins(
                  fontSize: 16,
                  color: fontBlueSky,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: pink, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kosan.kosAddress ?? '',
                style: PoppinsStyle.stylePoppins(
                  fontSize: 16,
                  color: fontBlueSky,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: bgBlue,
                    border: Border.all(color: pink, width: 2),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: bgBlue),
                    onPressed:
                        () => {
                          Get.toNamed(RouteNames.detailKos, arguments: kosan),
                        },
                    child: Text(
                      'Detail',
                      style: PoppinsStyle.stylePoppins(
                        color: fontBlueSky,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
