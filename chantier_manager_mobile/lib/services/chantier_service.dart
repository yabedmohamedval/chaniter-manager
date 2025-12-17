import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


import '../config/api_config.dart';
import '../models/anomalie.dart';
import '../models/chantier.dart';
import '../models/enums.dart';
import '../models/photo_chantier.dart';
import 'auth_service.dart';

class ChantierService {
  final AuthService _authService;

  ChantierService(this._authService);

  Future<List<Chantier>> getChantiers() async {
    final token = await _authService.getToken();
    final url = Uri.parse('${ApiConfig.apiBaseUrl}/chantiers');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => Chantier.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception('Non autorisé (token invalide ou expiré)');
    } else {
      throw Exception(
          'Erreur backend (${response.statusCode}) : ${response.body}');
    }
  }

  Future<Chantier> updateChantier(Chantier chantier) async {
    final token = await _authService.getToken();
    final url = Uri.parse('${ApiConfig.apiBaseUrl}/chantiers/${chantier.id}');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(chantier.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Chantier.fromJson(json);
    } else {
      throw Exception(
          'Erreur lors de la mise à jour (${response.statusCode}) : ${response.body}');
    }
  }

  Future<Chantier> changeStatut(int chantierId, StatutChantier nouveau) async {
    final token = await _authService.getToken();
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}/api/chantiers/$chantierId/statut');

    final resp = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'statut': nouveau.name, // "EN_COURS", "TERMINE", etc.
      }),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return Chantier.fromJson(data);
    } else {
      throw Exception('Erreur backend ${resp.statusCode}');
    }
  }

  Future<List<Anomalie>> getAnomalies(int chantierId) async {
    final token = await _authService.getToken();
    final uri = Uri.parse(
        '${ApiConfig.apiBaseUrl}/chantiers/$chantierId/anomalies');

    final resp = await http.get(
      uri,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Token utilisé pour anomalies: $token');
    print('Status anomalies = ${resp.statusCode}');
    print('le url est : $uri');
    print('Body anomalies = ${resp.body}');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as List<dynamic>;
      return data
          .map((e) => Anomalie.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } else {
      throw Exception('Erreur backend ${resp.statusCode}');
    }
  }

  Future<Anomalie> createAnomalie(int chantierId, String description) async {
    final token = await _authService.getToken();
    final uri = Uri.parse(
        '${ApiConfig.apiBaseUrl}/chantiers/$chantierId/anomalies');

    final resp = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'description': description}),
    );

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return Anomalie.fromJson(data);
    } else {
      throw Exception('Erreur backend ${resp.statusCode}');
    }
  }

  Future<void> uploadAnomaliePhoto(int anomalieId, XFile imageFile) async {
    final token = await _authService.getToken();
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}/anomalies/$anomalieId/photos');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
    // ne PAS mettre 'Content-Type' ici, MultipartRequest le gère
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',              // doit matcher @RequestParam("file") côté Spring
          imageFile.path,
          filename: imageFile.name,
        ),
      );

    final streamed = await request.send();
    final resp = await http.Response.fromStream(streamed);

    print('Status upload = ${resp.statusCode}');
    print('Body upload = ${resp.body}');

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Erreur upload photo ${resp.statusCode}: ${resp.body}');
    }
  }




// Tu pourras ajouter plus tard :
// Future<Chantier> createChantier(...)
}
