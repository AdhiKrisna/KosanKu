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
        await SessionManager.clear(
          oldEmail: emailController.text,
          oldPass: passwordController.text,
        );
        Get.snackbar(
          'Sukses',
          successMessage.value,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (e.toString().contains('session')) {
        Get.snackbar(
          'Access Token Expired $oldEmail',
          e.toString().replaceFirst('Exception: ', ''),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
        await SessionManager.clear(oldEmail: oldEmail, oldPass: oldPass);
        Get.offAllNamed(RouteNames.landing);
        return;
      }
      Get.snackbar(
        'Gagal memperbarui profil',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   nameController.clear();
  //   phoneController.clear();
  //   emailController.clear();
  //   passwordController.clear();
  //   super.onClose();
  // }
}
