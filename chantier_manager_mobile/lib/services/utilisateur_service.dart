// services/utilisateur_service.dart
import '../config/api_config.dart';
import '../models/utilisateur_light.dart';
import 'api_client.dart';

class UtilisateurService {
  final ApiClient _api;
  UtilisateurService(this._api);

  Future<List<UtilisateurLight>> getByRole(String role) async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/utilisateurs?role=$role") as List;
    return data.map((e) => UtilisateurLight.fromJson(e)).toList();
  }
}
