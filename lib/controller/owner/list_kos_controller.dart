import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosanku/models/kos_image_model.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/services/kos_image_service.dart';
import 'package:kosanku/services/kos_service.dart';

class ListKosController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  // final kosList = <Kos>[].obs;
  final kosImageMap = <int, List<KosImage>>{}.obs;
  var kosList = <Kos>[].obs;

  Future<void> getKosByOwnerId(int ownerId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await KosService.getKosByOwnerId(ownerId);
      print('Data from getKosByOwnerId: $data');
      final kosModel = KosModel.fromJson(data);

      if (kosModel.data != null) {
        kosList.assignAll(kosModel.data!);

        for (var kos in kosList) {
          final data = await KosImageService.getImagesByKosId(kos.id!);
          final kosImageModel = KosImageModel.fromJson(data);
          if (kosImageModel.data != null) {
            kosImageMap[kos.id!] = kosImageModel.data!;
            // print('Kos ID: ${kos.id}, Images: ${kosImageModel.data!.length}');
          } else {
            kosImageMap[kos.id!] = []; // Kosongkan jika null
          }
        }
      } else {
        kosList.clear();
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value.replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteKos(int kosId, User currentUser) async {
    log('Deleting kos with ID: $kosId');
    log('Using token: ${currentUser.userToken}');
    //user email
    log('User email: ${currentUser.userEmail}');

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await KosService.deleteKos(kosId, currentUser.userToken!);
      if (response['status'] == 'success') {
        kosList.removeWhere((kos) => kos.id == kosId);
        kosImageMap.remove(kosId);
        Get.snackbar(
          'Berhasil',
          'Kos berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Yahh, Gagal Menghapus Kosanmu :(( ',
          response['message'] ?? 'Terjadi kesalahan',
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      if (e.toString().contains('session')) {
        Get.snackbar(
          'Access Token Expired',
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        Get.offAllNamed(RouteNames.landing);
        return;
      }
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
