import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/anomalie.dart';
import '../models/chantier.dart';
import '../models/enums.dart';
import '../models/vehicule.dart';
import '../services/auth_service.dart';
import '../services/chantier_service.dart';

class ChantierProvider extends ChangeNotifier {
  late final ChantierService _chantierService;

  List<Chantier> _chantiers = [];
  bool _loading = false;
  String? _error;

  List<Vehicule> assigned = [];
  List<Vehicule> available = [];

  ChantierProvider(AuthService authService) {
    _chantierService = ChantierService(authService);
  }

  List<Chantier> get chantiers => _chantiers;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> loadChantiers() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _chantiers = await _chantierService.getChantiers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateChantier(Chantier chantier) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _chantierService.updateChantier(chantier);
      await loadChantiers(); // recharge la liste après update
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> changeStatut(int chantierId, StatutChantier nouveau) async {
    try {
      _error = null;
      notifyListeners();

      final updated = await _chantierService.changeStatut(chantierId, nouveau);

      final index = _chantiers.indexWhere((c) => c.id == chantierId);
      if (index != -1) {
        _chantiers[index] = updated;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Anomalie>> getAnomalies(int chantierId) {
    return _chantierService.getAnomalies(chantierId);
  }

  Future<Anomalie> createAnomalie(int chantierId, String description) {
    return _chantierService.createAnomalie(chantierId, description);
  }

  Future<void> uploadAnomaliePhoto(int anomalieId, XFile file) {
    return _chantierService.uploadAnomaliePhoto(anomalieId, file);
  }


}
