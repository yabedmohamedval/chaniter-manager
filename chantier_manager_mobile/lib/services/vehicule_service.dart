import '../config/api_config.dart';
import '../models/vehicule.dart';
import 'api_client.dart';

class VehiculeService {
  final ApiClient _api;
  VehiculeService(this._api);

  Future<List<Vehicule>> getAll() async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/vehicules") as List;
    return data.map((e) => Vehicule.fromJson(e)).toList();
  }

  Future<Vehicule> getById(int id) async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/vehicules/$id");
    return Vehicule.fromJson(data);
  }

  Future<Vehicule> create({
    String? immatriculation,
    String? type,
    String? libelle,
    bool disponible = true,
  }) async {
    final body = {
      "immatriculation": immatriculation,
      "type": type,
      "libelle": libelle,
      "disponible": disponible,
    };
    final data = await _api.postJson("${ApiConfig.apiBaseUrl}/vehicules", body);
    return Vehicule.fromJson(data);
  }

  Future<Vehicule> update({
    required int id,
    String? immatriculation,
    String? type,
    String? libelle,
    required bool disponible,
  }) async {
    final body = {
      "immatriculation": immatriculation,
      "type": type,
      "libelle": libelle,
      "disponible": disponible,
    };
    final data = await _api.putJson("${ApiConfig.apiBaseUrl}/vehicules/$id", body);
    return Vehicule.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _api.deleteNoBody("${ApiConfig.apiBaseUrl}/vehicules/$id");
  }
}
