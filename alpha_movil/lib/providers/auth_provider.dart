import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/trophy.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Map<String, dynamic> _userData = {}; // Hash Table / Map para acceso O(1)
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get userData => Map.unmodifiable(_userData);

  User? get user {
    if (_userData['user'] != null) {
      return _userData['user'] as User;
    }
    return null;
  }

  List<Trophy> get trophies {
    if (_userData['trophies'] != null) {
      return _userData['trophies'] as List<Trophy>;
    }
    return [];
  }

  // Inicializa el provider y carga datos guardados
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final userEmail = prefs.getString('userEmail');
      final userName = prefs.getString('userName');

      if (userId != null && userEmail != null && userName != null) {
        // Restaurar datos básicos del usuario
        _userData['user'] = User(
          id: userId,
          name: userName,
          email: userEmail,
          passwordHash: '',
        );
        _isAuthenticated = true;

        // Cargar trofeos
        await loadTrophies();
      }
    } catch (e) {
      _errorMessage = 'Error al inicializar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(email, password);

      // Guardar en el Map (Hash Table) para acceso O(1)
      _userData['user'] = user;
      _userData['email'] = user.email;
      _userData['name'] = user.name;
      _userData['id'] = user.id;

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('userEmail', user.email);
      await prefs.setString('userName', user.name);

      _isAuthenticated = true;

      // Cargar trofeos
      await loadTrophies();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.register(name, email, password);

      // Después de registrar, hacer login automático
      return await login(email, password);
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cargar trofeos del usuario
  Future<void> loadTrophies() async {
    if (!_isAuthenticated || _userData['id'] == null) return;

    try {
      final userId = _userData['id'] as int;
      final trophies = await _apiService.getTrophies(userId);
      _userData['trophies'] = trophies;
      notifyListeners();
    } catch (e) {
      // Error silencioso, no crítico
      debugPrint('Error al cargar trofeos: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    _isAuthenticated = false;
    _userData.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Actualizar datos del usuario en el Map (sin hacer fetch a la API)
  void updateUserData(String key, dynamic value) {
    _userData[key] = value;
    notifyListeners();
  }
}

