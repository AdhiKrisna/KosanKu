import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/detail_kos_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailKosPage extends GetView<DetailKosController> {
  const DetailKosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: pink,
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
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: pink),
              );
            }
            if (controller.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${controller.errorMessage}',
                  style: PoppinsStyle.stylePoppins(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            }

            final kos = controller.kosDetail.value;
            log('KOS NAMA dari page: ${kos?.kosName}');
            if (kos == null) {
              return Center(
                child: Text(
                  'Kos tidak ditemukan',
                  style: PoppinsStyle.stylePoppins(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Center(
                  child: Text(
                    kos.kosName ?? 'Nama Kos',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlueSky,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.275,
                    decoration: BoxDecoration(
                      border: Border.all(color: pink, width: 2),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.kosImageList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            controller.kosImageList[index].imageUrl ?? '',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.275,
                            width: MediaQuery.of(context).size.width * 0.6,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text(
                                    'Gagal memuat gambar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kategori: ${kos.category ?? '-'}',
                      style: PoppinsStyle.stylePoppins(
                        color: fontBlueSky,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sisa: ${kos.roomAvailable ?? '-'} Kamar',
                      style: PoppinsStyle.stylePoppins(
                        color: fontBlueSky,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(height: 3, color: bgBlue),
                Text(
                  'Deskripsi',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  kos.kosDescription ?? 'Tidak ada deskripsi',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 16,
                  ),
                ),
                Container(height: 3, color: bgBlue),
                Text(
                  'Peraturan',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  kos.kosRules ?? 'Pemilik kos belum mengisi peraturan',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 16,
                  ),
                ),
                Container(height: 3, color: bgBlue),
                Text(
                  'Alamat',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  kos.kosRules ?? 'Pemilik kos belum mengisi peraturan',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 16,
                  ),
                ),
                Container(height: 3, color: bgBlue),
                Text(
                  'Informasi Tambahan',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Range Harga: Rp. ${kos.minPrice ?? '-'} - Rp. ${kos.maxPrice ?? '-'}',
                  style: PoppinsStyle.stylePoppins(
                    color: fontBlueSky,
                    fontSize: 16,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Google Maps: ',
                      style: PoppinsStyle.stylePoppins(
                        color: fontBlueSky,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final url = kos.linkGmaps;
                        if (url != null && await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          Get.snackbar(
                            'Oops!',
                            'Link Google Maps tidak bisa dibuka',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Text(
                        kos.linkGmaps ?? 'Link Google Maps tidak tersedia',
                        style: PoppinsStyle.stylePoppins(
                          color: Colors.blue.shade700,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'No. Pemilik Kos: ',
                      style: PoppinsStyle.stylePoppins(
                        color: fontBlueSky,
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final phone = kos.ownerPhone;
                        if (phone != null) {
                          Clipboard.setData(ClipboardData(text: phone));
                          Fluttertoast.showToast(
                            msg: "Nomor disalin ke clipboard",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                          );
                        }
                      },
                      child: Text(
                        kos.ownerPhone ??
                            'Nomor telepon pemilik kos tidak tersedia',
                        style: PoppinsStyle.stylePoppins(
                          color: Colors.blue.shade700,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      final phone = kos.ownerPhone;
                      final waNumber = phone?.replaceFirst('0', '+62');
                      final url = 'https://wa.me/$waNumber';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        Get.snackbar(
                          'Oops!',
                          'Tidak bisa membuka WhatsApp',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Chat WhatsApp',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
