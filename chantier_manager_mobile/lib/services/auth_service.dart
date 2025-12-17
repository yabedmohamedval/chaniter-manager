import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';
import '../models/utilisateur.dart';

class AuthService {
  static const _tokenKey = 'jwt_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.apiBaseUrl}/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: _tokenKey, value: token);
      return token;
    } else {
      return null;
    }
  }

  Future<String?> register({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('${ApiConfig.apiBaseUrl}/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'telephone': telephone,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String;
      await _storage.write(key: _tokenKey, value: token);
      return token;
    } else {
      return null;
    }
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<Utilisateur> getMe() async {
    final token = await getToken();
    final url = Uri.parse('${ApiConfig.apiBaseUrl}/auth/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Utilisateur.fromJson(data);
    } else {
      throw Exception("Erreur backend ${response.statusCode}");
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
