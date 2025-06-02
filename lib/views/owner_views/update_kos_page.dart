import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/owner/update_kos_controller.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:kosanku/views/widgets/text_formfield_widget.dart';
import 'package:get/get.dart';

class UpdateKosPage extends GetView<UpdateKosController> {
  const UpdateKosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBody,
      appBar: AppBar(
        title: Text(
          'Edit Kos',
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
                    },
                    decoration: InputDecoration(border: InputBorder.none),
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
                      'source': 'update',
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
                  'Tambah Gambar',
                  style: PoppinsStyle.stylePoppins(
                    color: bgBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return controller.newImageFiles.isNotEmpty
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          controller.newImageFiles.length,
                          (index) {
                            final file = controller.newImageFiles[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      file,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _errorImage(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.removeNewImage(index);
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Upload Gambar Baru ->',
                              style: PoppinsStyle.stylePoppins(
                                color: fontBlueSky,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed:
                                  () => {
                                    //confirmation dialog
                                    //check if newImageFiles is > 5
                                    if (controller.newImageFiles.length > 5)
                                      {
                                        Get.snackbar(
                                          'Ups, gambarmu banyak banget!',
                                          'Maksimal cuma 5 gambar baru yang bisa diupload :(',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      }
                                    else
                                      Get.defaultDialog(
                                        title: 'Konfirmasi',
                                        middleText:
                                            'Apakah kamu yakin ingin mengupload gambar baru?',
                                        titleStyle: PoppinsStyle.stylePoppins(
                                          color: bgBody,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        middleTextStyle:
                                            PoppinsStyle.stylePoppins(
                                              color: bgBody,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        backgroundColor: pink,
                                        confirm: ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.uploadNewImages();
                                          },
                                          child: Text(
                                            'Ya',
                                            style: PoppinsStyle.stylePoppins(
                                              color: bgBody,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        cancel: ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: Text(
                                            'Tidak',
                                            style: PoppinsStyle.stylePoppins(
                                              color: bgBody,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  },
                              icon: const Icon(Icons.cloud_upload, color: pink),
                              tooltip: 'Upload Gambar Baru',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  : const SizedBox.shrink();
            }),

            Container(
              decoration: BoxDecoration(
                color: pink,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: pink, width: 2),
              ),
            ),
            const SizedBox(height: 8),

            Obx(() {
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(controller.currentImageFiles.length, (
                  index,
                ) {
                  final image = controller.currentImageFiles[index];
                  final imgUrl = image['imgUrl'];
                  final id = image['id']; // id gambar dari server

                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => _errorImage(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: 'Konfirmasi Hapus',
                                  middleText:
                                      'Apakah kamu yakin ingin menghapus gambar ini?',
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
                                  confirm: ElevatedButton(
                                    onPressed: () async {
                                      Get.back();
                                      await controller.deleteImageByKosID(
                                        id,
                                        index,
                                      );
                                    },
                                    child: Text('Ya'),
                                  ),
                                  cancel: ElevatedButton(
                                    onPressed: () => Get.back(),
                                    child: Text('Tidak'),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 0,
                        right: 60,
                        child: // Icon edit
                            GestureDetector(
                          onTap: () async {
                            await controller.updateSingleImage(
                              imageId: id,
                              index: index,
                            );
                          },
                          child: const Icon(
                            Icons.image,
                            color: fontBlueSky,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: pink, width: 2),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        //confirmation dialog
                        Get.defaultDialog(
                          title: 'Konfirmasi Update',
                          middleText:
                              'Apakah kamu yakin ingin menyimpan perubahan kos ini?',
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
                          confirm: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              controller.updateKos();
                            },
                            child: Text(
                              'Ya',
                              style: PoppinsStyle.stylePoppins(
                                color: bgBody,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          cancel: ElevatedButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Tidak',
                              style: PoppinsStyle.stylePoppins(
                                color: bgBody,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                        'Simpan Perubahan',
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

  Widget _errorImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.red),
    );
  }
}
