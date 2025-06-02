import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/services/kos_service.dart';
import 'package:latlong2/latlong.dart';

class AddKosController extends GetxController {
  final isLoading = false.obs;

  // Form Controllers
  final kosNameController = TextEditingController();
  final kosAddressController = TextEditingController();
  final kosDescriptionController = TextEditingController();
  final kosRulesController = TextEditingController();
  final linkGmapsController = TextEditingController();
  final roomAvailableController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minPriceController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  var selectedCategory = ''.obs;
  RxBool isLocationSelected = false.obs;

  final RxList<File> imageFiles = <File>[].obs;
  late User currentUser;
  @override
  void onInit() {
    super.onInit();
    currentUser = Get.arguments as User;
    print('User token from arguments: ${currentUser.userToken}');
    print('User ID from arguments: ${currentUser.userId}');
  }

  void setLatLong(LatLng position) {
    log('MASUK SET LAT LONG');
    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();
    isLocationSelected.value = true;
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      imageFiles.addAll(pickedFiles.map((file) => File(file.path)).toList());
    } else {
      Get.snackbar(
        'Info',
        'Tidak ada gambar yang dipilih',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void removeImage(int index) {
    imageFiles.removeAt(index);
  }

  Future<void> submitKos() async {
    if (kosNameController.text.isEmpty ||
        kosAddressController.text.isEmpty ||
        kosDescriptionController.text.isEmpty ||
        selectedCategory.value.isEmpty ||
        kosRulesController.text.isEmpty ||
        linkGmapsController.text.isEmpty ||
        roomAvailableController.text.isEmpty ||
        minPriceController.text.isEmpty ||
        maxPriceController.text.isEmpty ||
        latitudeController.text.isEmpty ||
        longitudeController.text.isEmpty) {
      Get.snackbar(
        'Yahh, Gagal Menambahkan Kosan Mu :(( ',
        'Mohon lengkapi semua data wajib!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (imageFiles.isEmpty) {
      Get.snackbar(
        'Yahh, Gagal Menambahkan Kosan Mu :(( ',
        'Minimal unggah 1 gambar kos',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    isLoading.value = true;

    if (isLoading.value) {
      Center(child: CircularProgressIndicator());
    }
    try {
      final response = await KosService.createKos(
        token: currentUser.userToken ?? '',
        kosName: kosNameController.text.trim(),
        kosAddress: kosAddressController.text.trim(),
        kosDescription: kosDescriptionController.text.trim(),
        kosRules: kosRulesController.text.trim(),
        category: selectedCategory.value,
        linkGmaps: linkGmapsController.text.trim(),
        roomAvailable: int.tryParse(roomAvailableController.text) ?? 0,
        maxPrice: int.tryParse(maxPriceController.text) ?? 0,
        minPrice: int.tryParse(minPriceController.text) ?? 0,
        kosLatitude: double.tryParse(latitudeController.text) ?? 0.0,
        kosLongitude: double.tryParse(longitudeController.text) ?? 0.0,
        ownerKosId: currentUser.userId ?? 0,
        images: imageFiles,
      );

      if (response['status'] == 'success') {
        Get.offAllNamed(RouteNames.mainScreen, arguments: currentUser);
        Get.snackbar(
          'Berhasil',
          'Kos berhasil ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 3),
        );
        return;
      } else {
        if (response['message'] == 'Invalid token' ||
            response['statusCode'] == 403) {
          Get.snackbar(
            'Access Token Expired',
            'Sesi kamu telah habis, silakan login ulang.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          Get.offAllNamed(RouteNames.landing);
          return;
        }

        Get.snackbar(
          'Yahh, Gagal Menambahkan Kosanmu :(( ',
          response['message'] ?? 'Terjadi kesalahan',
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      log('Error saat submit kos: $e');
      if (e.toString().contains('session'))  {
        Get.snackbar(
          'Access Token Expired',
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
        // SessionManager.clear(
        //   oldEmail: currentUser.userEmail ?? '',
        //   oldPass: currentUser.userPassword ?? '',
        // );
        Get.offAllNamed(RouteNames.landing);
        return;
      }

      Get.snackbar(
        'Error',
        'Gagal menambahkan kosan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    kosNameController.dispose();
    kosAddressController.dispose();
    kosDescriptionController.dispose();
    kosRulesController.dispose();
    linkGmapsController.dispose();
    selectedCategory.value = '';
    roomAvailableController.dispose();
    maxPriceController.dispose();
    minPriceController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    imageFiles.clear();

    super.onClose();
  }
}
