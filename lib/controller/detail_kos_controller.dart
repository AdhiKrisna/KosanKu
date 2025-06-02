import 'dart:developer';
import 'package:get/get.dart';
import 'package:kosanku/models/kos_image_model.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/services/kos_image_service.dart';
import 'package:kosanku/services/kos_service.dart';

class DetailKosController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final kosDetail = Rxn<Kos>();
  final kosImageList = <KosImage>[].obs;

   Future<void> fetchKosDetail(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await KosService.getKosDetail(id);
      kosDetail.value = Kos.fromJson(data['data']); 
      // log(('KOS NAMA: ${kosDetail.value?.kosName}'));
    } catch (e) {
      errorMessage.value = e.toString();
      log('Failed to load kos detail: ${errorMessage.value}');
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
  void onInit() {
    super.onInit();
    final kosArg = Get.arguments;
    log('KOS ARGUMENTS: ${kosArg.id}');
    if (kosArg != null && kosArg.id != null) {
      fetchKosDetail(kosArg.id.toString());
      fetchKosImageByID(kosArg.id);
    } else {
      errorMessage.value = 'ID Kos tidak valid';
    }
  }
}
