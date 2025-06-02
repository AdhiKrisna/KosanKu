import 'package:get/get.dart';
import 'package:kosanku/controller/detail_kos_controller.dart';

class DetailKosBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailKosController());
  }
  
}