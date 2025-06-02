import 'dart:async';
import 'package:get/get.dart';
import 'package:kosanku/routes/route_names.dart';

class LandingController extends GetxController {
  RxBool isSwapped = false.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      isSwapped.value = !isSwapped.value;
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void goToLoginPage() {
    Get.toNamed(RouteNames.login);
  }
  void goToMainMapPage() {
    Get.toNamed(RouteNames.mainMap);
  }
}
