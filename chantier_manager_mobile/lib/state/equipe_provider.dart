// providers/equipe_provider.dart
import 'package:flutter/foundation.dart';
import '../models/equipe.dart';
import '../services/equipe_service.dart';

class EquipeProvider extends ChangeNotifier {
  final EquipeService _service;
  EquipeProvider(this._service);

  bool loading = false;
  String? error;

  List<Equipe> equipes = [];
  Equipe? selected;

  Future<void> fetchAll() async {
    loading = true; error = null; notifyListeners();
    try {
      equipes = await _service.getAll();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> fetchById(int id) async {
    loading = true; error = null; notifyListeners();
    try {
      selected = await _service.getById(id);
      _upsertInList(selected!);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  // ---- NEW: actions métier ----

  Future<void> addMembre({required int equipeId, required int userId}) async {
    loading = true; error = null; notifyListeners();
    try {
      final updated = await _service.addMembre(equipeId, userId);
      _applyUpdatedEquipe(updated);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> removeMembre({required int equipeId, required int userId}) async {
    loading = true; error = null; notifyListeners();
    try {
      final updated = await _service.removeMembre(equipeId, userId);
      _applyUpdatedEquipe(updated);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> changeChef({required int equipeId, required int chefId}) async {
    loading = true; error = null; notifyListeners();
    try {
      final updated = await _service.changeChef(equipeId, chefId);
      _applyUpdatedEquipe(updated);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  // ---- helpers cache ----

  void _applyUpdatedEquipe(Equipe updated) {
    if (selected?.id == updated.id) selected = updated;
    _upsertInList(updated);
  }

  void _upsertInList(Equipe e) {
    final idx = equipes.indexWhere((x) => x.id == e.id);
    if (idx == -1) {
      equipes = [e, ...equipes];
    } else {
      equipes = [...equipes]..[idx] = e;
    }
  }
}
