import 'dart:developer';

import 'package:get/get.dart';
import 'dart:async';

import 'package:kosanku/managers/session_manager.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';

class SplashController extends GetxController {
  var opacity = 0.0.obs;
  var progress = 0.0.obs; // 0.0 - 1.0

  @override
  void onInit() {
    super.onInit();
    showSplash();
  }

  void showSplash() {
    Timer(const Duration(milliseconds: 500), () {
      opacity.value = 1.0;
    });

    // Jalankan progress bar selama 5 detik
    const duration = 5; // detik
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final tick = timer.tick / (duration * 20); // 50ms × 100 = 5s
      if (tick >= 1.0) {
        progress.value = 1.0;
        timer.cancel();
        checkSession();
      } else {
        progress.value = tick;
      }
    });
  }

  Future<void> checkSession() async {
    final userData = await SessionManager.getUserData();
    log('User data retrieved from session: ${userData['token']}');
    if (userData['token'] != null) {
      User user = User(
        userId: userData['id'] as int?,
        userEmail: userData['email'] as String?,
        userPassword: userData['password'] as String?,
        userName: userData['username'] as String?,
        userPhone: userData['phone'] as String?,
        userToken: userData['token'] as String?,
      );
      Get.offNamed(RouteNames.mainScreen, arguments: user);
    } else {
      Get.offNamed(RouteNames.landing);
    }
  }
}
