import 'dart:developer';

import 'package:get/get.dart';
import 'package:kosanku/models/kos_image_model.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/services/kos_image_service.dart';
import 'package:kosanku/services/kos_service.dart';
import 'package:latlong2/latlong.dart';

class MapPickerController extends GetxController {
  final kosList = <Kos>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final kosImageList = <KosImage>[].obs;
  late Rx<LatLng> selectedPosition;
  late Map<String, dynamic> args;
  String source = '';
  dynamic controller;

  @override
  void onInit() {
    super.onInit();
      // amanin akses Get.arguments
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      print('Get.arguments is not null');
      args = Get.arguments;
      source = args['source'] ?? '';
      controller = args['controller'];
      print('source: $source');
      print('controller: $controller');
      selectedPosition = Rx<LatLng>(
        LatLng(
          args['lat'] ?? -7.782279034876108,
          args['long'] ?? 110.41620335724352,
        ),
      );
    } else {
      // fallback default kalau nggak ada argumen (dipakai di MainMapPage)
      selectedPosition = Rx<LatLng>(
        const LatLng(-7.782279034876108, 110.41620335724352),
      );
    }
    fetchKos();
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

  Future<void> fetchKosImageByID(int id) async{
    try{
      isLoading.value = true;
      errorMessage.value = '';
      final data = await KosImageService.getImagesByKosId(id);
      final kosImageModel = KosImageModel.fromJson(data);
      if(kosImageModel.data != null){
        kosImageList.assignAll(kosImageModel.data!);
      } else {
        kosImageList.clear();
      }
    }catch(e){
      errorMessage.value = e.toString();
      log('Failed to load kos image: ${errorMessage.value}');
    }
  }

  @override
  void onClose() {
    kosList.clear();
    kosImageList.clear();
    super.onClose();
  }
}
