import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/models/kos_image_model.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/services/kos_image_service.dart';
import 'package:kosanku/services/kos_service.dart';
import 'package:latlong2/latlong.dart';

class UpdateKosController extends GetxController {
  final isLoading = false.obs;

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

  final RxList<Map<String, dynamic>> currentImageFiles =
      <Map<String, dynamic>>[].obs;
  late User currentUser;
  late Kos currentKos;

  late List<KosImage> currentImages;
  final RxList<File> newImageFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    currentUser = args['user'] as User;
    currentKos = args['kos'] as Kos;
    kosNameController.text = currentKos.kosName.toString();
    kosAddressController.text = currentKos.kosAddress.toString();
    kosDescriptionController.text = currentKos.kosDescription.toString();
    kosRulesController.text = currentKos.kosRules.toString();
    selectedCategory.value = currentKos.category.toString();
    linkGmapsController.text = currentKos.linkGmaps.toString();
    roomAvailableController.text = currentKos.roomAvailable.toString();
    maxPriceController.text = currentKos.maxPrice.toString();
    minPriceController.text = currentKos.minPrice.toString();
    latitudeController.text = currentKos.kosLatitude.toString();
    longitudeController.text = currentKos.kosLongitude.toString();
    isLocationSelected.value = true;

    loadImages();
  }

  Future<void> loadImages() async {
    try {
      isLoading.value = true;
      final response = await KosImageService.getImagesByKosId(currentKos.id!);
      // print('Response: $response');
      final kosImageModel = KosImageModel.fromJson(response);
      currentImages = kosImageModel.data ?? [];
      // for (var img in currentImages) {
      //   print('Image ID: ${img.imageId}, URL: ${img.imageUrl}');
      // }
      currentImageFiles.assignAll(
        currentImages.map((img) => {'id': img.imageId, 'imgUrl': img.imageUrl}),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      newImageFiles.addAll(picked.map((file) => File(file.path)).toList());
    } else {
      Get.snackbar(
        'Info',
        'Tidak ada gambar yang dipilih',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  // Memanggil API untuk hapus image lama (by ID)
  Future<void> deleteImageByKosID(int id, int index) async {
    try {
      isLoading.value = true;
      final token = currentUser.userToken;
      await KosImageService.deleteKosImage(imageId: id, token: token!);
      currentImageFiles.removeAt(index);
      Get.snackbar(
        'Sukses',
        'Gambar berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back(); // Kembali ke halaman sebelumnya
    } catch (e) {
      if (e.toString().contains('session')) {
        Get.snackbar(
          'Access Token Expired',
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        Get.offAllNamed(RouteNames.landing);
        return;
      }
      log('Error deleting image: $e');
      Get.snackbar(
        'Error',
        'Gagal menghapus gambar',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setLatLong(LatLng position) {
    latitudeController.text = position.latitude.toString();
    longitudeController.text = position.longitude.toString();
    isLocationSelected.value = true;
  }

  void removeNewImage(int index) {
    newImageFiles.removeAt(index);
  }

  void removeImage(int index) {
    currentImageFiles.removeAt(index);
  }

  Future<void> updateKos() async {
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
        'Gagal Update',
        'Mohon lengkapi semua data wajib!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // 1. Update data utama kos (tanpa gambar)
      final kosResponse = await KosService.updateKos(
        updatedKos: Kos(
          id: currentKos.id,
          kosName: kosNameController.text.trim(),
          kosAddress: kosAddressController.text.trim(),
          kosDescription: kosDescriptionController.text.trim(),
          kosRules: kosRulesController.text.trim(),
          category: selectedCategory.value,
          linkGmaps: linkGmapsController.text.trim(),
          roomAvailable: int.tryParse(roomAvailableController.text) ?? 0,
          maxPrice: int.tryParse(maxPriceController.text) ?? 0,
          minPrice: int.tryParse(minPriceController.text) ?? 0,
          kosLatitude: latitudeController.text,
          kosLongitude: longitudeController.text,
        ),
        user: currentUser,
      );

      if (kosResponse['status'] == 'success') {
        Get.offAllNamed(RouteNames.mainScreen, arguments: currentUser);
        Get.snackbar(
          'Berhasil',
          'Kos berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 3),
        );
        return;
      } else {
        if (kosResponse['message'] == 'Invalid token' ||
            kosResponse['statusCode'] == 403) {
          print('Access token expired dari try updateKos');
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
          kosResponse['message'] ?? 'Terjadi kesalahan',
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          backgroundColor: Colors.red,
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(seconds: 5),
        );
      }
    } catch (e) {
      if (e.toString().contains('session')) {
        log(
          'Old Email: ${currentUser.userEmail}, Old Password: ${currentUser.userPassword}',
        );
        Get.snackbar(
          'Access Token Expired',
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
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

  //per images an duniawi
  Future<void> uploadNewImages() async {
    try {
      if (newImageFiles.isEmpty) return;

      isLoading.value = true;
      //loading snackbar circular indicator
      if (isLoading.value) {
        Get.snackbar(
          'Mengunggah Gambar',
          'Mohon tunggu, sedang mengunggah gambar...',
          backgroundColor: bgBlue,
          colorText: pink,
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      final token = currentUser.userToken;
      final response = await KosImageService.addKosImages(
        kosId: currentKos.id!,
        images: newImageFiles,
        token: token!,
      );

      if (response['status'] != 'success') {
        Get.snackbar(
          'Gagal Unggah',
          'Gagal mengunggah gambar: ${response['message']}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      await loadImages();
      newImageFiles.clear();
      Get.snackbar(
        'Sukses',
        'Gambar berhasil diunggah',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (e.toString().contains('session')) {
        Get.snackbar(
          'Access Token Expired',
          //remove Exception: dari pesan error
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
        );
        Get.offAllNamed(RouteNames.landing);
        return;
      }
      Get.snackbar(
        'Error',
        'Gagal mengunggah gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSingleImage({
    required int imageId,
    required int index,
  }) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage == null) return;

      // Tampilkan preview dan konfirmasi
      final isConfirmed = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: pink, width: 2),
          ),
          backgroundColor: bgBody,
          title: Text(
            'Konfirmasi Gambar',
            style: PoppinsStyle.stylePoppins(
              color: pink,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kamu yakin ingin menggunakan gambar ini?',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlueSky,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Image.file(
                File(pickedImage.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: bgBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: pink, width: 2),
                ),
              ),
              onPressed: () => Get.back(result: false),
              child: Text(
                'Batal',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlueSky,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: bgBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: pink, width: 2),
                ),
              ),
              onPressed: () => Get.back(result: true),
              child: Text(
                'Gunakan',
                style: PoppinsStyle.stylePoppins(
                  color: fontBlueSky,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (isConfirmed != true) return;

      isLoading.value = true;

      Get.snackbar(
        'Mengunggah Gambar',
        'Sedang memperbarui gambar...',
        backgroundColor: bgBlue,
        colorText: pink,
        snackPosition: SnackPosition.BOTTOM,
      );

      final token = currentUser.userToken;
      final response = await KosImageService.updateKosImage(
        imageId: imageId,
        newImage: File(pickedImage.path),
        token: token!,
      );

      if (response['status'] == 'success') {
        // Refresh ulang gambar
        await loadImages();
        Get.snackbar(
          'Sukses',
          'Gambar berhasil diperbarui',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal update gambar: ${response['message']}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
      } else {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
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
    roomAvailableController.dispose();
    maxPriceController.dispose();
    minPriceController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}
