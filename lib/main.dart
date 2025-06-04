import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/routes/route_pages.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Minta izin notifikasi (khusus Android 13+)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInit,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(MyApp());
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
