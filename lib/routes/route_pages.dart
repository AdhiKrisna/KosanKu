import 'package:kosanku/bindings/auth_bindings.dart';
import 'package:kosanku/bindings/detail_kos_bindings.dart';
import 'package:kosanku/bindings/landing_bindings.dart';
import 'package:kosanku/bindings/main_bindings.dart';
import 'package:kosanku/bindings/owner_kos_bindings.dart';
import 'package:kosanku/bindings/splash_bindings.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/views/detail_kos_page.dart';
import 'package:kosanku/views/landing_page.dart';
import 'package:kosanku/views/login_page.dart';
import 'package:kosanku/views/main_map_page.dart';
import 'package:kosanku/views/owner_views/add_kos_page.dart';
import 'package:kosanku/views/owner_views/main_screen.dart';
import 'package:kosanku/views/owner_views/map_picker.dart';
import 'package:kosanku/views/owner_views/update_kos_page.dart';
import 'package:kosanku/views/register_page.dart';
import 'package:kosanku/views/splash_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';

class RoutePages {
  List<GetPage> routes = [
    GetPage(
      name: RouteNames.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteNames.landing,
      page: () => const LandingPage(),
      binding: LandingBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.mainMap,
      page: () => MainMapPage(),
      binding: MainBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.detailKos,
      page: () => const DetailKosPage(),
      binding: DetailKosBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.cupertino,
    ),


    GetPage(
      name: RouteNames.mainScreen,
      page: () =>  MainScreen(),
      binding: MainBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.addKos,
      page: () => const AddKosPage(),
      binding: OwnerKosBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteNames.updateKos,
      page: () => const UpdateKosPage(),
      binding: OwnerKosBinding(),
      transition: Transition.cupertino,
    ),
     GetPage(
      name: RouteNames.mapPicker,
      page: () =>  MapPickerPage(),
      binding: MainBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
