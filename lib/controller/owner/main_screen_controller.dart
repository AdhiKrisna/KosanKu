import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/views/main_map_page.dart';
import 'package:kosanku/views/owner_views/list_kos_page.dart';
import 'package:kosanku/views/owner_views/profile_page.dart';

class MainScreenController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt get currentIndexValue => currentIndex;

  void changeIndex(int index) {
    log('Changing index to: $index');
    currentIndex.value = index;
  }

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Kosanku'),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Map Kos'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  List<Widget> pages = [];

  @override
  void onInit() {
    super.onInit();
    final user = Get.arguments as User;
    log('Arguments received: ${user.toJson()}');
    log('User ID: ${user.userId}');
    log('User Token: ${user.userToken}');
    pages = [
      ListKosPage(user: user),
      MainMapPage(),
      ProfilePage(user: user),
    ];
  }
}
