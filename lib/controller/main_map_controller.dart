import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:kosanku/models/kos_image_model.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/services/kos_image_service.dart';
import 'package:kosanku/services/kos_service.dart';

class MainMapController extends GetxController {
  final kosList = <Kos>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final kosImageList = <KosImage>[].obs;
  final mapController = MapController();
  final currentTime = ''.obs;
  @override
  void onInit() {
    super.onInit();
    // fallback default kalau nggak ada argumen (dipakai di MainMapPage)
    fetchKos();
    updateTime();
  }

  void updateTime() {
    final now = DateTime.now().toUtc();

    final wib = now.add(const Duration(hours: 7)); // UTC+7
    final wita = now.add(const Duration(hours: 8)); // UTC+8
    final wit = now.add(const Duration(hours: 9)); // UTC+9

    final formatter = DateFormat('HH:mm');

    currentTime.value =
        '${formatter.format(wib)} WIB | ${formatter.format(wita)} WITA | ${formatter.format(wit)} WIT ';

    // Optional: update otomatis tiap menit
    Future.delayed(const Duration(minutes: 1), updateTime);
  }

  Future<void> fetchKos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await KosService.getKosList();
      final kosModel = KosModel.fromJson(data);
      if (kosModel.data != null) {
        kosList.assignAll(kosModel.data!);
      } else {
        kosList.clear();
      }
    } catch (e) {
      errorMessage.value = e.toString();
      log('Failed to load kos data: ${errorMessage.value}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchKosImageByID(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await KosImageService.getImagesByKosId(id);
      final kosImageModel = KosImageModel.fromJson(data);
      if (kosImageModel.data != null) {
        kosImageList.assignAll(kosImageModel.data!);
      } else {
        kosImageList.clear();
      }
    } catch (e) {
      errorMessage.value = e.toString();
      log('Failed to load kos image: ${errorMessage.value}');
    }
  }
}
