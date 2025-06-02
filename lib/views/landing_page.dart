import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/landing_controller.dart';
import 'package:get/get.dart';

class LandingPage extends GetView<LandingController> {
  const LandingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgBody,
        title: Text(
          'KosanKu',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: bgBody,
        width: double.infinity,
        height: double.infinity,
        child: Obx(() {
          bool isSwapped = controller.isSwapped.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // biar teks tetap di tengah, ini sebagai spacer atas
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Apa Peranmu?',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlueSky,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: 200,
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSwapped ? fontBlue2 : bgBlue,
                      ),
                      onPressed: () => {
                        controller.goToLoginPage(),
                      },
                      child: Text(
                        'Pemilik Kos',
                        style: PoppinsStyle.stylePoppins(
                          color: isSwapped ? bgBlue : fontBlue2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: 200,
                    height: 65,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSwapped ? bgBlue : fontBlue2,
                      ),
                      onPressed: () => {
                        controller.goToMainMapPage(),
                      },
                      child: Text(
                        'Pencari Kos',
                        style: PoppinsStyle.stylePoppins(
                          color: isSwapped ? fontBlue : bgBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '© 2025 KosanKu. All rights reserved.',
                  style: PoppinsStyle.stylePoppins(
                    color: pink,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
