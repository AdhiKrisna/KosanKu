import 'package:kosanku/controller/login_controller.dart';
import 'package:kosanku/controller/register_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(RegisterController());
  }
}
