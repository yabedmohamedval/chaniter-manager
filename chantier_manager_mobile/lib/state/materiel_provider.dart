import 'package:flutter/foundation.dart';
import '../models/materiel.dart';
import '../services/materiel_service.dart';

class MaterielProvider extends ChangeNotifier {
  final MaterielService _service;
  MaterielProvider(this._service);

  bool loading = false;
  String? error;

  List<Materiel> items = [];
  Materiel? selected;

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

  Future<void> create(String libelle, String? type, int quantiteTotale) async {
    loading = true; error = null; notifyListeners();
    try {
      final created = await _service.create(
        libelle: libelle,
        type: type,
        quantiteTotale: quantiteTotale,
      );
      items = [created, ...items];
    } catch (e) {
      error = e.toString();
    } finally { loading = false; notifyListeners(); }
  }

  Future<void> update(int id, String libelle, String? type, int quantiteTotale) async {
    loading = true; error = null; notifyListeners();
    try {
      final updated = await _service.update(
        id: id,
        libelle: libelle,
        type: type,
        quantiteTotale: quantiteTotale,
      );
      items = items.map((m) => m.id == id ? updated : m).toList();
      if (selected?.id == id) selected = updated;
    } catch (e) {
      error = e.toString();
    } finally { loading = false; notifyListeners(); }
  }

  Future<void> delete(int id) async {
    loading = true; error = null; notifyListeners();
    try {
      await _service.delete(id);
      items.removeWhere((m) => m.id == id);
      if (selected?.id == id) selected = null;
    } catch (e) {
      error = e.toString();
    } finally { loading = false; notifyListeners(); }
  }
}
