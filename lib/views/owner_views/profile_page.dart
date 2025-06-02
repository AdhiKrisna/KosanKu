import 'package:flutter/material.dart';
import 'package:kosanku/controller/owner/profile_controller.dart';
import 'package:kosanku/managers/session_manager.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:get/get.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/views/widgets/text_formfield_widget.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final ProfileController controller = Get.put(ProfileController());

  ProfilePage({super.key, required this.user}) {
    controller.initialize(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBody,
      appBar: AppBar(
        backgroundColor: bgBody,
        elevation: 0,
        foregroundColor: pink,
        title: Text(
          'Profil Saya',
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
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormFieldWidget(
              controller: controller.nameController,
              label: "Nama Lengkap",
            ),
            TextFormFieldWidget(
              controller: controller.phoneController,
              label: "Nomor HP",
            ),
            TextFormFieldWidget(
              controller: controller.emailController,
              label: "Email",
              // readOnly: true,
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
            Container(
              decoration: BoxDecoration(
                color: bgBlue,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: fontBlueSky, width: 2.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Konfirmasi Perubahan',
                    middleText: 'Yakin ingin memperbarui profil?',
                    textCancel: 'Batal',
                    textConfirm: 'Update',
                    titleStyle: PoppinsStyle.stylePoppins(
                      color: fontBlueSky,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    middleTextStyle: PoppinsStyle.stylePoppins(
                      color: fontBlueSky,
                      fontSize: 16,
                    ),
                    confirmTextColor: bgBody,
                    cancelTextColor: pink,
                    buttonColor: pink,
                    backgroundColor: bgBody,
                    onConfirm: () async {
                      Get.back(); // Tutup dialog dulu
                      await controller.updateProfile(
                        userId: user.userId ?? 0,
                        oldEmail: controller.emailController.text,
                        oldPass: controller.passwordController.text,
                      );
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: bgBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Obx(
                  () =>
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Update Profile',
                            style: PoppinsStyle.stylePoppins(
                              color: fontBlueSky,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Konfirmasi Logout',
                  middleText: 'Yakin mau logout?',
                  textCancel: 'Batal',
                  textConfirm: 'Logout',
                  titleStyle: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  middleTextStyle: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 16,
                  ),
                  confirmTextColor: bgBody,
                  cancelTextColor: pink,
                  buttonColor: pink,
                  backgroundColor: bgBody,
                  onConfirm: () async {
                    // print('User ID: ${user.userId}');
                    // print('User Email: ${user.userEmail}');
                    // print('User Password: ${user.userPassword}');
                    await SessionManager.clear(
                      oldEmail: controller.emailController.text,
                      oldPass: controller.passwordController.text,
                    );
                    Get.offAllNamed(RouteNames.landing);
                    Get.snackbar(
                      'Logout Berhasil',
                      'Kamu telah berhasil logout.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Logout',
                style: PoppinsStyle.stylePoppins(
                  color: bgBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
