import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosanku/controller/register_controller.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/views/widgets/text_formfield_widget.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBody,
      appBar: AppBar(
        backgroundColor: bgBody,
        elevation: 0,
        foregroundColor: pink,
        title: Text(
          'Register',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormFieldWidget(
              controller: controller.nameController,
              label: "Nama Lengkap",
            ),
            TextFormFieldWidget(
              controller: controller.emailController,
              label: "Email",
            ),
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
            Obx(
              () => TextFormFieldWidget(
                controller: controller.confirmPasswordController,
                label: "Konfirmasi Password",
                obscureText: !controller.isConfirmPasswordVisible.value,
                suffixIcon: IconButton(
                  onPressed: controller.toggleConfirmPasswordVisibility,
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: pink,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.register,
              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Register',
                style: PoppinsStyle.stylePoppins(
                  color: bgBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                    controller.goToLoginPage();
                  },
                  child: Text(
                    'Login',
                    style: PoppinsStyle.stylePoppins(color: pink, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
