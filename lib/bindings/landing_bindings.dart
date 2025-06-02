import 'package:get/get.dart';
import 'package:kosanku/controller/landing_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LandingController());
  }
}
