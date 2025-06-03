import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosanku/managers/session_manager.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/services/user_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void goToRegisterPage() {
    Get.toNamed(RouteNames.register);
  }

  @override
  void onInit() {
    super.onInit();
    _loadPrefilledCredentials();
  }

  void _loadPrefilledCredentials() async {
    final data = await SessionManager.getOldCredential();
    log('Data from session: $data');
    if (data['oldEmail'] != null) {
      emailController.text = data['oldEmail'];
    }
    if (data['oldPassword'] != null) {
      passwordController.text = data['oldPassword'];
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await UserService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if(isLoading.value) {
        Center(
          child: CircularProgressIndicator(),
        );
      }
      if (response.status == 'success') {
        final user = response.data!;
        // Simpan ke dalam session
        await SessionManager.saveUserSession(
          token: response.accessToken ?? '',
          id: user.userId ?? 0,
          name: user.userName ?? '',
          email: user.userEmail ?? '',
          phone: user.userPhone ?? '',
          password: passwordController.text, // simpan buat prefill
        );
        User userLogin = User(
          userId: user.userId,
          userEmail: user.userEmail,
          userPassword:   passwordController.text,
          userName: user.userName,
          userPhone: user.userPhone,
          userToken : response.accessToken,
        );
        Get.snackbar(
          'Login Berhasil... Horayy',
          'Kamu adalah calon kos owner yang sukses!!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 6),
        );

        Get.offAllNamed(RouteNames.mainScreen, arguments: userLogin);
      } else {
        errorMessage.value = response.message ?? 'Login gagal';
        Get.snackbar(
          'Login Gagal :(',
          errorMessage.value == 'User not found'
              ? errorMessage.value
              : 'Credential yang kamu input tidak valid. Coba lagi :)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: $e';
      log('Login failed: ${errorMessage.value}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
