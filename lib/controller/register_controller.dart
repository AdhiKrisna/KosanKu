import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosanku/services/user_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void goToLoginPage() {
    Get.back(); // kembali ke halaman login
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      final response = await UserService.register(
        name: nameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      if (response.status == 'success') {
        Get.snackbar(
          'Success',
          'Registrasi Sukses! Selangkah lagi untuk menjadi juragan kos yang sukses!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 6),
        );
        Get.offNamed('/login'); // Navigate to login page
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Registration failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        //remove the Exception part from the error message
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    super.onClose();
  }
}
