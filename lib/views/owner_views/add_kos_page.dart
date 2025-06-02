import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/owner/add_kos_controller.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/views/widgets/text_formfield_widget.dart';
import 'package:get/get.dart';

class AddKosPage extends GetView<AddKosController> {
  const AddKosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBody,
      appBar: AppBar(
        title: Text(
          'Tambah Kos',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgBody,
        foregroundColor: pink,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormFieldWidget(
              controller: controller.kosNameController,
              label: 'Nama Kos',
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.kosAddressController,
              label: 'Alamat Kos',
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.kosDescriptionController,
              label: 'Deskripsi Kos',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.kosRulesController,
              label: 'Peraturan Kos',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Kategori Kos',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Obx(() {
              final kategoriOptions = ['Putra', 'Putri', 'Campuran'];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgBlue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: pink, width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    dropdownColor: bgBlue,
                    style: PoppinsStyle.stylePoppins(
                      color: pink,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    hint: Text(
                      '(Putra/Putri/Campuran)',
                      style: PoppinsStyle.stylePoppins(
                        color: pink,
                        fontSize: 14,
                      ),
                    ),
                    value:
                        kategoriOptions.contains(
                              controller.selectedCategory.value,
                            )
                            ? controller.selectedCategory.value
                            : null,
                    items:
                        kategoriOptions.map((kategori) {
                          return DropdownMenuItem<String>(
                            value: kategori,
                            child: Text(
                              kategori,
                              style: PoppinsStyle.stylePoppins(
                                color: pink,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (newValue) {
                      controller.selectedCategory.value = newValue!;
                      log(
                        'Saved category: ${controller.selectedCategory.value}',
                      );
                    },
                    decoration: InputDecoration(
                      hintText: '(Putra/Putri/Campuran)',
                      hintStyle: TextStyle(color: pink, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.linkGmapsController,
              label: 'Link Gmaps',
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.roomAvailableController,
              label: 'Jumlah Kamar Tersedia',
              isNumber: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.minPriceController,
              label: 'Harga Minimum',
              isNumber: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldWidget(
              controller: controller.maxPriceController,
              label: 'Harga Maksimum',
              isNumber: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('check controller : $controller');
                  Get.toNamed(
                    RouteNames.mapPicker,
                    arguments: {
                      'lat': double.tryParse(
                        controller.latitudeController.text,
                      ),
                      'long': double.tryParse(
                        controller.longitudeController.text,
                      ),
                      'controller': controller,
                      'source': 'create',
                    },
                  );
                },
                icon: const Icon(Icons.map, color: bgBlue),
                label: Text(
                  "Pilih dari Peta",
                  style: PoppinsStyle.stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: bgBlue,
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: fontBlueSky),
              ),
            ),
            const SizedBox(height: 4),
            Obx(() {
              return Row(
                spacing: 8,
                children: [
                  const SizedBox(width: 8),
                  //icon
                  Icon(
                    controller.isLocationSelected.value
                        ? Icons.check_circle
                        : Icons.warning,
                    color:
                        controller.isLocationSelected.value
                            ? fontBlueSky
                            : pink,
                    size: 16,
                  ),
                  Text(
                    controller.isLocationSelected.value
                        ? 'Mantap, lokasi kos sudah dipilih!'
                        : 'Pilih lokasi kos mu di peta dulu yaa!',
                    style: PoppinsStyle.stylePoppins(
                      color:
                          controller.isLocationSelected.value
                              ? fontBlueSky
                              : pink,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: controller.pickImages,
                style: ElevatedButton.styleFrom(backgroundColor: fontBlueSky),
                child: Text(
                  'Pilih Gambar',
                  style: PoppinsStyle.stylePoppins(
                    color: bgBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            Obx(() {
              if (controller.imageFiles.isEmpty) {
                return Row(
                  children: [
                    const Icon(Icons.warning, color: pink, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Tidak ada gambar yang dipilih',
                      style: PoppinsStyle.stylePoppins(
                        color: pink,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }

              // Debug log
              for (var file in controller.imageFiles) {
                debugPrint("Image path: ${file.path}");
                debugPrint("File exists: ${File(file.path).existsSync()}");
              }

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  controller.imageFiles.length,
                  (index) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(controller.imageFiles[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(index),
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Obx(() {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: pink, width: 3),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        //confirm before submitting
                        //check if images > 5
                        if (controller.imageFiles.length > 5) {
                          Get.snackbar(
                            'Error',
                            'Maksimal 5 gambar yang bisa diunggah',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            icon: const Icon(Icons.error, color: Colors.white),
                            snackStyle: SnackStyle.FLOATING,
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }
                        Get.defaultDialog(
                          title: 'Konfirmasi Tambah Kos',
                          middleText:
                              'Apakah Anda yakin ingin menambahkan kos ini?',
                              
                          titleStyle: PoppinsStyle.stylePoppins(
                            color: bgBody,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          middleTextStyle: PoppinsStyle.stylePoppins(
                            color: bgBody,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          backgroundColor: pink,
                          onConfirm: () async {
                            Get.back();
                            //loading
                            controller.submitKos();
                          },
                          onCancel: () {
                            Get.back();
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
                      child: Text(
                        'Tambah Kos',
                        style: PoppinsStyle.stylePoppins(
                          color: pink,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
            }),
          ],
        ),
      ),
    );
  }
}
