import 'package:flutter/foundation.dart';
import '../models/vehicule.dart';
import '../services/chantier_vehicule_service.dart';

class ChantierVehiculeProvider extends ChangeNotifier {
  final ChantierVehiculeService _service;
  ChantierVehiculeProvider(this._service);

  bool loading = false;
  String? error;

  List<Vehicule> assigned = [];
  List<Vehicule> available = [];

  Future<void> load(int chantierId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      assigned = await _service.getVehiculesDuChantier(chantierId);
      available = await _service.getVehiculesDisponibles();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> affecter(int chantierId, int vehiculeId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      await _service.affecter(chantierId, vehiculeId);
      await load(chantierId); // refresh
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> desaffecter(int chantierId, int vehiculeId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      await _service.desaffecter(chantierId, vehiculeId);
      await load(chantierId); // refresh
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
