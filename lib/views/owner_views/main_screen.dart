import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/controller/owner/main_screen_controller.dart';
import 'package:get/get.dart';

class MainScreen extends GetView<MainScreenController> {
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // print('Arguments received: $args. User ID: ${args?.userId}, Username: ${args?.userName}, Email: ${args?.userEmail}, Phone: ${args?.userPhone}');
    return Scaffold(
  
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: controller.items, 
          currentIndex: controller.currentIndexValue.value,
          onTap: (value) => controller.changeIndex(value),
          selectedItemColor: fontBlue,
          unselectedItemColor: pink,
          backgroundColor: bgBody,
        ),
      ),

      body: Obx(
        () => controller.pages[controller.currentIndexValue.value],
      ),
    );
  }
}
