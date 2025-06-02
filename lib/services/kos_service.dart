import 'dart:convert';
import 'dart:io';
import 'package:kosanku/constants/constant_secrets.dart';
import 'package:kosanku/models/kos_model.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:http/http.dart' as http;

class KosService {
  static const String _baseApiUrl = apiUrl;

  static Future<Map<String, dynamic>> getKosList() async {
    final response = await http.get(Uri.parse('$_baseApiUrl/kos'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getKosDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseApiUrl/kos/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load kos detail');
    }
  }

  static Future<Map<String, dynamic>> getKosByOwnerId(int ownerId) async {
    final response = await http.get(
      Uri.parse('$_baseApiUrl/kos/owner/$ownerId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load kos by owner ID');
    }
  }

  /// POST: Buat kos baru (wajib dengan minimal 1 gambar)
  static Future<Map<String, dynamic>> createKos({
    required String kosName,
    required String kosAddress,
    String? kosDescription,
    String? kosRules,
    required String category,
    required String linkGmaps,
    required int roomAvailable,
    required int maxPrice,
    required int minPrice,
    required int ownerKosId,
    required double kosLatitude,
    required double kosLongitude,
    required List<File> images,
    required String token,
  }) async {
    var uri = Uri.parse('$_baseApiUrl/kos');
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields.addAll({
      'kos_name': kosName,
      'kos_address': kosAddress,
      'kos_description': kosDescription ?? '',
      'kos_rules': kosRules ?? '',
      'category': category,
      'link_gmaps': linkGmaps,
      'room_available': roomAvailable.toString(),
      'max_price': maxPrice.toString(),
      'min_price': minPrice.toString(),
      'owner_kos_id': ownerKosId.toString(),
      'kos_latitude': kosLatitude.toString(),
      'kos_longitude': kosLongitude.toString(),
    });

    for (File image in images) {
      var multipartFile = await http.MultipartFile.fromPath(
        'image_url',
        image.path,
      );
      request.files.add(multipartFile);
    }

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        throw Exception(
          'Yah, session kamu sudah habis, silakan login ulang yaa',
        );
      }
      throw Exception('Failed to create kos: ${response.body}');
    }
  }

  /// PUT: Update hanya data kos (tanpa gambar)
  static Future<Map<String, dynamic>> updateKos({
    required Kos updatedKos,
    required User user,
  }) async {
    final url = Uri.parse('$_baseApiUrl/kos/${updatedKos.id}');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.userToken}',
      },
      body: jsonEncode({
        "kos_name": updatedKos.kosName,
        "kos_address": updatedKos.kosAddress,
        "kos_description": updatedKos.kosDescription,
        "kos_rules": updatedKos.kosRules,
        "category": updatedKos.category,
        "link_gmaps": updatedKos.linkGmaps,
        "room_available": updatedKos.roomAvailable,
        "max_price": updatedKos.maxPrice,
        "min_price": updatedKos.minPrice,
        "kos_latitude": double.tryParse(updatedKos.kosLatitude ?? '0.0'),
        "kos_longitude": double.tryParse(updatedKos.kosLongitude ?? '0.0'),
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        throw Exception(
          'Yah, session kamu sudah habis, silakan login ulang yaa',
        );
      }
      throw Exception('Failed to update kos: ${response.body}');
    }
  }

  /// DELETE: Hapus satu kos (otomatis hapus gambar juga via backend)
  static Future<Map<String, dynamic>> deleteKos(int kosId, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseApiUrl/kos/$kosId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      if (response.statusCode == 403) {
        throw Exception(
          'Yah, session kamu sudah habis, silakan login ulang yaa',
        );
      }
      throw Exception('Failed to delete kos: ${response.body}');
    }
  }
}
