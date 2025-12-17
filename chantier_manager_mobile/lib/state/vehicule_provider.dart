import 'package:flutter/foundation.dart';
import '../models/vehicule.dart';
import '../services/vehicule_service.dart';

class VehiculeProvider extends ChangeNotifier {
  final VehiculeService _service;
  VehiculeProvider(this._service);

  bool loading = false;
  String? error;

  List<Vehicule> items = [];
  Vehicule? selected;

  Future<void> fetchAll() async {
    loading = true; error = null; notifyListeners();
    try { items = await _service.getAll(); }
    catch (e) { error = e.toString(); }
    finally { loading = false; notifyListeners(); }
  }

  Future<void> fetchById(int id) async {
    loading = true; error = null; notifyListeners();
    try { selected = await _service.getById(id); }
    catch (e) { error = e.toString(); }
    finally { loading = false; notifyListeners(); }
  }

  Future<void> create(String? immat, String? type, String? libelle, bool dispo) async {
    loading = true; error = null; notifyListeners();
    try {
      final created = await _service.create(
        immatriculation: immat,
        type: type,
        libelle: libelle,
        disponible: dispo,
      );
      items = [created, ...items];
    } catch (e) {
      error = e.toString();
    } finally { loading = false; notifyListeners(); }
  }

  Future<void> update(int id, String? immat, String? type, String? libelle, bool dispo) async {
    loading = true; error = null; notifyListeners();
    try {
      final updated = await _service.update(
        id: id,
        immatriculation: immat,
        type: type,
        libelle: libelle,
        disponible: dispo,
      );
      items = items.map((v) => v.id == id ? updated : v).toList();
      if (selected?.id == id) selected = updated;
    } catch (e) {
      error = e.toString();
    } finally { loading = false; notifyListeners(); }
  }

  Future<void> delete(int id) async {
    loading = true; error = null; notifyListeners();
    try {
      await _service.delete(id);
      items.removeWhere((v) => v.id == id);
      if (selected?.id == id) selected = null;
    } catch (e) {
      error = e.toString();
    } finally { loading = false; notifyListeners(); }
  }
}
