import 'package:get/get.dart';
import 'package:kosanku/controller/owner/add_kos_controller.dart';
import 'package:kosanku/controller/owner/update_kos_controller.dart';

class OwnerKosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddKosController>(() => AddKosController());
    Get.lazyPut<UpdateKosController>(() => UpdateKosController());
  }
}
