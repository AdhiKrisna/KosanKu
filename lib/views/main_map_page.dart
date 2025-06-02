import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/location_controller.dart';
import 'package:kosanku/controller/main_map_controller.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MainMapPage extends GetView<MainMapController> {
  MainMapPage({super.key});
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
          'KosanKu',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: bgBody,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: pink));
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${controller.errorMessage}',
                style: PoppinsStyle.stylePoppins(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }

          if (controller.kosList.isEmpty) {
            return Center(
              child: Text(
                'No kos data available',
                style: PoppinsStyle.stylePoppins(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }

          // Default center di kos pertama
          'TES Error: ${controller.errorMessage}';
          final firstKos = controller.kosList.first;
          final defaultCenter = LatLng(
            double.tryParse(firstKos.kosLatitude ?? '') ?? -7.7829,
            double.tryParse(firstKos.kosLongitude ?? '') ?? 110.367,
          );

          // Buat list of markers
          final markers =
              controller.kosList
                  .map((kos) {
                    final lat = double.tryParse(kos.kosLatitude ?? '');
                    final long = double.tryParse(kos.kosLongitude ?? '');
                    if (lat == null || long == null) return null;
                    return Marker(
                      point: LatLng(lat, long),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () => _showKosanBottomSheet(context, kos),
                        child: Column(
                          children: [
                            const Icon(Icons.home, color: bgBody, size: 26),
                            Text(
                              kos.kosName ?? '',
                              style: PoppinsStyle.stylePoppins(
                                fontSize: 12,
                                color: bgBody,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                  .whereType<Marker>()
                  .toList();
          // Tambahkan ke dalam list markers
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

          return FlutterMap(
            options: MapOptions(
              initialCenter: defaultCenter,
              initialZoom: 14.0,
              minZoom: 5.0,
              maxZoom: 20.0,
            ),
            children: [
              TileLayer(
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        }),
      ),
    );
  }

  void _showKosanBottomSheet(BuildContext context, Kos kosan) async {
    await controller.fetchKosImageByID(kosan.id ?? 0);

    // Cek apakah context-nya masih aktif
    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: bgBody,
      // useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 250,
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
                            onError: (exception, stackTrace) {
                              log('Error loading image: $exception');
                              Get.snackbar(
                                'Error',
                                'Failed to load kos image',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            },
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 16),
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
                          // print('Navigating to detail page for $kosan'),
                          // print('Navigating to detail page for ${kosan.kosName}'),
              
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
    ).then((_) async {
      controller.isLoading.value = true;
      await controller.fetchKos();
      controller.isLoading.value = false;
    });
  }
}
