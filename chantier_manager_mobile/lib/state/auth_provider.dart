import 'package:flutter/foundation.dart';
import '../models/enums.dart';
import '../services/auth_service.dart';
import '../models/utilisateur.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  Utilisateur? currentUser;
  String? _token;
  bool _loading = false;
  String? _error;
  bool get isChef => currentUser?.role == RoleUtilisateur.CHEF_CHANTIER;
  bool get isResponsable => currentUser?.role == RoleUtilisateur.RESPONSABLE_CHANTIERS;


  AuthProvider(this._authService) {
    _loadTokenOnStart();
  }

  bool get isLoggedIn => _token != null;
  bool get isLoading => _loading;
  String? get error => _error;
  String? get token => _token;

  Future<void> _loadTokenOnStart() async {
    _token = await _authService.getToken();
    if (_token != null) {
      try {
        currentUser = await _authService.getMe();
      } catch (_) {
        // token expiré => logout silencieux
        await _authService.logout();
        _token = null;
        currentUser = null;
      }
    }
    notifyListeners();
  }


  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final token = await _authService.login(email, password);

    if (token == null) {
      _loading = false;
      _error = 'Email ou mot de passe incorrect';
      notifyListeners();
      return false;
    }

    _token = token;

    try {
      currentUser = await _authService.getMe();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
    return currentUser != null;
  }



  Future<void> logout() async {
    await _authService.logout();
    _token = null;
    currentUser = null;
    notifyListeners();
  }

}
