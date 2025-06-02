import 'package:flutter/material.dart';
import 'package:kosanku/controller/login_controller.dart';
import 'package:kosanku/views/widgets/text_formfield_widget.dart';
import 'package:get/get.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBody,
      appBar: AppBar(
        backgroundColor: bgBody,
        elevation: 0,
        foregroundColor: pink,
        title: Text(
          'Login',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormFieldWidget(
                controller: controller.emailController,
                label: "Email",
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextFormFieldWidget(
                  controller: controller.passwordController,
                  label: "Password",
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: pink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Login',
                    style: PoppinsStyle.stylePoppins(
                      color: bgBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun?',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlueSky,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.goToRegisterPage();
                    },
                    child: Text(
                      'Register',
                      style: PoppinsStyle.stylePoppins(
                        color: pink,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
