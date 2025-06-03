import 'dart:convert';
import 'package:kosanku/managers/session_manager.dart';
import 'package:kosanku/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:kosanku/constants/constant_secrets.dart';

class UserService {
  static const String _baseUrl = apiUrl;

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_email': email, 'user_password': password}),
    );

    return UserModel.fromJson(jsonDecode(response.body));
  }

  static Future<UserModel> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_name': name,
        'user_phone': phone,
        'user_email': email,
        'user_password': password,
      }),
    );
    return UserModel.fromJson(jsonDecode(response.body));
  }

  static Future<dynamic> updateProfile({
    required int userId,
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/profile/$userId');
    final accessToken =
        await SessionManager.getToken(); // pastikan ini method-nya bener
    print('Access Token: $accessToken'); // Debugging token
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken", // Tambahin Bearer token
      },
      body: jsonEncode({
        "user_name": name,
        "user_phone": phone,
        "user_email": email,
        "user_password": password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      body['statusCode'] = response.statusCode; // Tambahin manual di body
      return body;
    } else if (response.statusCode == 403) {
      throw Exception('Yah, session kamu sudah habis, silakan login ulang yaa');
    } else {
      throw Exception('Gagal memperbarui profil: ${response.body}');
    }
  }
}
