import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveUserSession({
    required String token,
    required int id,
    required String name,
    required String email,
    required String phone,
    required String password, // tambahkan untuk prefill
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
    await prefs.setInt('userId', id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPhone', phone);
    await prefs.setString('userPassword', password); // prefill UX++
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('userId'),
      'email': prefs.getString('userEmail'),
      'password': prefs.getString('userPassword'),
      'username': prefs.getString('userName'),
      'phone': prefs.getString('userPhone'),
      'token': prefs.getString('accessToken'),
    };
  }

  static Future<void> saveOldCredential({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('oldEmail', email);
    await prefs.setString('oldPassword', password);
  }

  static Future<void> clear({
    required String oldEmail,
    required String oldPass,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await saveOldCredential(email: oldEmail, password: oldPass);
  }

  static Future<Map<String, dynamic>> getOldCredential() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'oldEmail': prefs.getString('oldEmail'),
      'oldPassword': prefs.getString('oldPassword'),
    };
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'accessToken',
    ); // atau nama key-nya sesuai yang kamu simpan
  }
}
