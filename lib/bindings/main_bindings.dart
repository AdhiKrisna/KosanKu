import 'package:get/get.dart';
import 'package:kosanku/controller/location_controller.dart';
import 'package:kosanku/controller/main_map_controller.dart';
import 'package:kosanku/controller/owner/main_screen_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainMapController());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => MainScreenController());
  }
}
 