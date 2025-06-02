import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';
import 'package:kosanku/controller/owner/list_kos_controller.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:kosanku/routes/route_names.dart';
import 'package:get/get.dart';

class ListKosPage extends StatelessWidget {
  final ListKosController controller = Get.put(ListKosController());
  final User user;
  ListKosPage({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    controller.getKosByOwnerId(user.userId ?? 0);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: pink,
        backgroundColor: bgBody,
        centerTitle: true,
        title: Text(
          'Daftar Kosanku',
          style: PoppinsStyle.stylePoppins(
            color: pink,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: bgBody,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: bgBlue,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: pink, width: 2.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(RouteNames.addKos, arguments: user);
                  },
                  child: Text(
                    'Tambah Kos Lagi Ah',
                    style: PoppinsStyle.stylePoppins(
                      color: fontBlueSky,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /// Obx reactive UI
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.kosList.isEmpty) {
                    return Center(child: Text("Belum ada kos 😢"));
                  }

                  return ListView.builder(
                    itemCount: controller.kosList.length,
                    itemBuilder: (context, index) {
                      final kos = controller.kosList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.detailKos, arguments: kos);
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: fontBlue2, width: 3.0),
                              borderRadius: BorderRadius.circular(8.0),
                              color: bgBlue,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kos.kosName ?? 'Nama Kos Tidak Tersedia',
                                  style: PoppinsStyle.stylePoppins(
                                    color: pink,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  height: 250,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: pink, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        controller
                                                .kosImageMap[kos.id]
                                                ?.first
                                                .imageUrl ??
                                            'https://via.placeholder.com/150',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Alamat: ${kos.kosAddress ?? 'Alamat Tidak Tersedia'}',
                                  style: PoppinsStyle.stylePoppins(
                                    color: fontBlueSky,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: bgBlue,
                                          side: BorderSide(
                                            color: fontBlue2,
                                            width: 2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.toNamed(
                                            RouteNames.updateKos,
                                            arguments: {
                                              'kos': kos,
                                              'user': user,
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Edit Kos',
                                          style: PoppinsStyle.stylePoppins(
                                            color: pink,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: pink,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: 'Konfirmasi Hapus',
                                            middleText:
                                                'Apakah Anda yakin ingin menghapus kos ini?',
                                            titleStyle:
                                                PoppinsStyle.stylePoppins(
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
                                            onConfirm: () async {
                                              Get.back();
                                              await controller.deleteKos(
                                                kos.id ?? 0,
                                                user,
                                              );
                                            },
                                            onCancel: () {
                                              Get.back();
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Hapus Kos',
                                          style: PoppinsStyle.stylePoppins(
                                            color: bgBlue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
