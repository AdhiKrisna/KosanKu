import 'package:flutter/material.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/routes/route_pages.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
   return GetMaterialApp(
      title: 'Kosan Ku',
      debugShowCheckedModeBanner: false,
      getPages: RoutePages().routes,
      initialRoute: RouteNames.splash,
    );
  }
}
