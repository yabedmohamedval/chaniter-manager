import '../config/api_config.dart';
import '../models/materiel.dart';
import 'api_client.dart';

class MaterielService {
  final ApiClient _api;
  MaterielService(this._api);

  Future<List<Materiel>> getAll() async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/materiels") as List;
    return data.map((e) => Materiel.fromJson(e)).toList();
  }

  Future<Materiel> getById(int id) async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/materiels/$id");
    return Materiel.fromJson(data);
  }

  Future<Materiel> create({
    required String libelle,
    String? type,
    required int quantiteTotale,
  }) async {
    final body = {
      "libelle": libelle,
      "type": type,
      "quantiteTotale": quantiteTotale,
    };
    final data = await _api.postJson("${ApiConfig.apiBaseUrl}/materiels", body);
    return Materiel.fromJson(data);
  }

  Future<Materiel> update({
    required int id,
    required String libelle,
    String? type,
    required int quantiteTotale,
  }) async {
    final body = {
      "libelle": libelle,
      "type": type,
      "quantiteTotale": quantiteTotale,
    };
    final data = await _api.putJson("${ApiConfig.apiBaseUrl}/materiels/$id", body);
    return Materiel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _api.deleteNoBody("${ApiConfig.apiBaseUrl}/materiels/$id");
  }
}
