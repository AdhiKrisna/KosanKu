import 'dart:convert';
import 'dart:io';
import 'package:kosanku/constants/constant_secrets.dart';
import 'package:http/http.dart' as http;

class KosImageService {
  static const String _baseApiUrl = apiUrl;

  /// GET: Semua gambar pada kos tertentu
  static Future<Map<String, dynamic>> getImagesByKosId(int kosId) async {
    final response = await http.get(
      Uri.parse('$_baseApiUrl/kos-images/kos/$kosId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load kos images');
    }
  }

  /// POST: Tambah gambar (multi-upload) ke kos tertentu
  static Future<Map<String, dynamic>> addKosImages({
    required int kosId,
    required List<File> images,
    required String token,
  }) async {
    var uri = Uri.parse('$_baseApiUrl/kos-images/kos/$kosId');
    var request = http.MultipartRequest('POST', uri);

    // Set Authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Tambahkan semua file gambar
    for (File image in images) {
      var multipartFile = await http.MultipartFile.fromPath(
        'image_url',
        image.path,
      );
      request.files.add(multipartFile);
    }

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        throw Exception(
          'Yah, session kamu sudah habis, silakan login ulang yaa',
        );
      }
      throw Exception('Failed to upload kos images');
    }
  }

  /// PUT: Update satu gambar berdasarkan ID
  static Future<Map<String, dynamic>> updateKosImage({
    required int imageId,
    required File newImage,
    required String token,
  }) async {
    var uri = Uri.parse('$_baseApiUrl/kos-images/$imageId');
    var request = http.MultipartRequest('PUT', uri);

    request.headers['Authorization'] = 'Bearer $token';

    var multipartFile = await http.MultipartFile.fromPath(
      'image_url',
      newImage.path,
    );
    request.files.add(multipartFile);

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        throw Exception(
          'Yah, session kamu sudah habis, silakan login ulang yaa',
        );
      }
      throw Exception('Failed to update kos image');
    }
  }

  /// DELETE: Hapus satu gambar kos
  static Future<Map<String, dynamic>> deleteKosImage({
    required int imageId,
    required String token,
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseApiUrl/kos-images/$imageId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        throw Exception(
          'Yah, session kamu sudah habis, silakan login ulang yaa',
        );
      }
      throw Exception('Failed to delete kos image');
    }
  }
}
