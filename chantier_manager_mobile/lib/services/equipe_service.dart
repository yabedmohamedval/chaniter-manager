// services/equipe_service.dart
import '../config/api_config.dart';
import '../models/equipe.dart';
import 'api_client.dart';

class EquipeService {
  final ApiClient _api;
  EquipeService(this._api);

  Future<List<Equipe>> getAll() async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/equipes") as List;
    return data.map((e) => Equipe.fromJson(e)).toList();
  }

  Future<Equipe> getById(int id) async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/equipes/$id");
    return Equipe.fromJson(data);
  }

  Future<Equipe> addMembre(int equipeId, int userId) async {
    final data = await _api.postJson(
      "${ApiConfig.apiBaseUrl}/equipes/$equipeId/membres/$userId",
      {},
    );
    return Equipe.fromJson(data);
  }

  Future<Equipe> removeMembre(int equipeId, int userId) async {
    final data = await _api.deleteJson(
      "${ApiConfig.apiBaseUrl}/equipes/$equipeId/membres/$userId",
    );
    return Equipe.fromJson(data);
  }

  Future<Equipe> changeChef(int equipeId, int chefId) async {
    final data = await _api.putJson(
      "${ApiConfig.apiBaseUrl}/equipes/$equipeId/chef/$chefId",
      {},
    );
    return Equipe.fromJson(data);
  }

  Future<void> deleteEquipe(int id) async {
    await _api.deleteNoBody("${ApiConfig.apiBaseUrl}/equipes/$id");
  }
}
