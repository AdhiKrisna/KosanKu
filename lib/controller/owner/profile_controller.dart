import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosanku/managers/session_manager.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/services/user_service.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void initialize(User user) {
    nameController.text = user.userName ?? '';
    phoneController.text = user.userPhone ?? '';
    emailController.text = user.userEmail ?? '';
    passwordController.text = user.userPassword ?? '';
  }

  Future<void> updateProfile({
    required int userId,
    required String oldEmail,
    required String oldPass,
  }) async {
    isLoading.value = true;
    try {
      final response = await UserService.updateProfile(
        userId: userId,
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      // print('Response: $response');
      final statusCode = response['statusCode'];
      if (statusCode == 200) {
        successMessage.value = 'Profile berhasil diperbarui';
        // final mainController = Get.find<MainScreenController>();
        // print('masuk sini kah?');
        await SessionManager.clear(oldEmail: emailController.text, oldPass: passwordController.text);

        Get.snackbar(
          'Sukses',
          successMessage.value,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (statusCode == 403) {
        errorMessage.value =
            response['message'] ?? 'Akses ditolak. Silakan login ulang';
        Get.offAllNamed(RouteNames.landing);
        Get.snackbar(
          'Akses Ditolak',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (statusCode == 400) {
        errorMessage.value = response['message'] ?? 'Permintaan tidak valid';
        Get.snackbar(
          'Gagal',
          errorMessage.value,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (statusCode == 409) {
        errorMessage.value = response['message'] ?? 'Data sudah digunakan';
        Get.snackbar(
          errorMessage.value,
          'Email atau nomor telepon sudah terdaftar oleh pengguna lain',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = 'Gagal memperbarui profil';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
