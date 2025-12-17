import '../config/api_config.dart';
import '../models/vehicule.dart';
import 'api_client.dart';

class ChantierVehiculeService {
  final ApiClient _api;
  ChantierVehiculeService(this._api);

  Future<List<Vehicule>> getVehiculesDuChantier(int chantierId) async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/chantiers/$chantierId/vehicules") as List;
    return data.map((e) => Vehicule.fromJson(e)).toList();
  }

  Future<List<Vehicule>> getVehiculesDisponibles() async {
    final data = await _api.getJson("${ApiConfig.apiBaseUrl}/vehicules/disponibles") as List;
    return data.map((e) => Vehicule.fromJson(e)).toList();
  }

  Future<void> affecter(int chantierId, int vehiculeId) async {
    await _api.postJson("${ApiConfig.apiBaseUrl}/chantiers/$chantierId/vehicules/$vehiculeId", {});
  }

  Future<void> desaffecter(int chantierId, int vehiculeId) async {
    await _api.deleteNoBody("${ApiConfig.apiBaseUrl}/chantiers/$chantierId/vehicules/$vehiculeId");
  }
}
