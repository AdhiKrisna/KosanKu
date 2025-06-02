import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bgBody,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Column(
                  children: [
                    // Judul
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 1500),
                      opacity: controller.opacity.value,
                      child: Text(
                        'KosanKu',
                        style: PoppinsStyle.stylePoppins(
                          color: pink,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Progress bar
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 20,
                      decoration: BoxDecoration(
                        color: fontBlueSky,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: MediaQuery.of(context).size.width * 0.8 * controller.progress.value,
                        decoration: BoxDecoration(
                          color: pink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Text persentase
                    Text(
                      '${(controller.progress.value * 100).toInt()}%',
                      style: PoppinsStyle.stylePoppins(
                        color: fontBlueSky,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
