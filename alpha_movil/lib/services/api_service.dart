import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../models/user.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';
import '../models/trophy.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = Environment.apiBaseUrl;
  
  // Cliente HTTP con timeout configurado
  final http.Client _client = http.Client();
  
  // Timeout de 30 segundos
  static const Duration _timeout = Duration(seconds: 30);

  // Helper para hacer requests
  Future<Map<String, dynamic>> _makeRequest({
    required String action,
    Map<String, dynamic>? body,
    String method = 'GET',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl?action=$action');
      
      http.Response response;
      
      if (method == 'POST') {
        response = await _client
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: body != null ? jsonEncode(body) : null,
            )
            .timeout(_timeout);
      } else {
        // GET request
        Uri targetUri = uri;
        if (body != null) {
          // Mantener el parámetro 'action' y agregar los nuevos parámetros
          final queryParams = <String, String>{
            'action': action,
            ...body.map((key, value) => MapEntry(key, value.toString())),
          };
          targetUri = uri.replace(queryParameters: queryParams);
        }
        
        response = await _client
            .get(
              targetUri,
              headers: {'Accept': 'application/json'},
            )
            .timeout(_timeout);
      }

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          
          // El API PHP devuelve {'ok': true, 'data': ...} o {'ok': false, 'error': ...}
          if (decoded['ok'] == true) {
            return decoded;
          } else {
            throw Exception(decoded['error'] as String? ?? decoded['message'] as String? ?? 'Error desconocido');
          }
        } catch (e) {
          if (e is Exception) rethrow;
          throw Exception('Error al parsear respuesta JSON: $e');
        }
      } else {
        // Intentar parsear el error del API
        try {
          final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorBody['error'] as String? ?? 'Error HTTP ${response.statusCode}');
        } catch (_) {
          throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
        }
      }
    } on SocketException catch (e) {
      // Parsear la URL para obtener el host
      final parsedUri = Uri.tryParse(baseUrl);
      final host = parsedUri?.host ?? 'desconocida';
      
      throw Exception(
        'No se pudo conectar al servidor.\n'
        'Verifica que:\n'
        '1. El servidor esté ejecutándose en $baseUrl\n'
        '2. Tu PC y celular estén en la misma red WiFi\n'
        '3. El firewall permita conexiones en el puerto 8080\n'
        '4. La IP sea correcta (actual: $host)\n'
        'Error: ${e.message}'
      );
    } on HttpException catch (e) {
      throw Exception('Error HTTP: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Error al procesar la respuesta: ${e.message}');
    } on TimeoutException catch (e) {
      throw Exception(
        'Tiempo de espera agotado.\n'
        'El servidor no respondió en ${_timeout.inSeconds} segundos.\n'
        'Verifica que el servidor esté ejecutándose en $baseUrl'
      );
    } on Exception catch (e) {
      rethrow;
    } catch (e) {
      throw Exception('Error de conexión: $e\nVerifica que el servidor esté ejecutándose en $baseUrl');
    }
  }
  
  // Método para cerrar el cliente (útil para cleanup)
  void dispose() {
    _client.close();
  }

  // POST ?action=login
  Future<User> login(String email, String password) async {
    final response = await _makeRequest(
      action: 'login',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
      },
    );

    // El API devuelve: {'ok': true, 'data': {'user': {...}}}
    if (response['ok'] == true && response['data'] != null) {
      final data = response['data'] as Map<String, dynamic>;
      if (data['user'] != null) {
        return User.fromJson(data['user'] as Map<String, dynamic>);
      }
    }
    throw Exception(response['error'] as String? ?? 'Error al iniciar sesión');
  }

  // POST ?action=register
  Future<bool> register(String name, String email, String password) async {
    final response = await _makeRequest(
      action: 'register',
      method: 'POST',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    // El API devuelve: {'ok': true, 'data': {...}}
    if (response['ok'] == true) {
      return true;
    } else {
      throw Exception(response['error'] as String? ?? 'Error al registrar');
    }
  }

  // GET ?action=lessons
  Future<List<Lesson>> getLessons() async {
    final response = await _makeRequest(action: 'lessons');

    // El API devuelve: {'ok': true, 'data': [...]}
    if (response['ok'] == true && response['data'] != null) {
      final lessonsList = response['data'] as List<dynamic>;
      return lessonsList
          .map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['error'] as String? ?? 'Error al cargar lecciones');
    }
  }

  // GET ?action=lesson&id=ID
  Future<Lesson> getLessonDetail(int id) async {
    final response = await _makeRequest(
      action: 'lesson',
      body: {'id': id},
    );

    // El API devuelve: {'ok': true, 'data': {...}}
    if (response['ok'] == true && response['data'] != null) {
      return Lesson.fromJson(response['data'] as Map<String, dynamic>);
    } else {
      throw Exception(response['error'] as String? ?? 'Error al cargar lección');
    }
  }

  // GET ?action=quizByLesson&lessonId=ID
  Future<Quiz> getQuizByLesson(int lessonId) async {
    final response = await _makeRequest(
      action: 'quizByLesson',
      body: {'lessonId': lessonId},
    );

    // El API devuelve: {'ok': true, 'data': {'id': ..., 'lesson_id': ..., 'title': ..., 'questions': [...]}}
    if (response['ok'] == true && response['data'] != null) {
      final data = response['data'] as Map<String, dynamic>;
      debugPrint('Quiz cargado: ${data['title']}');
      debugPrint('Total de preguntas: ${(data['questions'] as List?)?.length ?? 0}');
      if (data['questions'] != null) {
        final questions = data['questions'] as List;
        for (var i = 0; i < questions.length; i++) {
          final q = questions[i] as Map<String, dynamic>;
          final text = q['text']?.toString() ?? 'sin texto';
          final textPreview = text.length > 50 ? text.substring(0, 50) : text;
          debugPrint('Pregunta ${i + 1}: $textPreview');
          debugPrint('  Respuestas: ${(q['answers'] as List?)?.length ?? 0}');
        }
      }
      return Quiz.fromJson(data);
    } else {
      throw Exception(response['error'] as String? ?? 'Error al cargar quiz');
    }
  }

  // POST ?action=saveResult
  Future<bool> saveResult({
    required int userId,
    required int quizId,
    required int correct,
    required int total,
  }) async {
    final response = await _makeRequest(
      action: 'saveResult',
      method: 'POST',
      body: {
        'userId': userId,
        'quizId': quizId,
        'correct': correct,
        'total': total,
      },
    );

    // El API devuelve: {'ok': true, 'data': {...}}
    if (response['ok'] == true) {
      return true;
    } else {
      throw Exception(response['error'] as String? ?? 'Error al guardar resultado');
    }
  }

  // GET ?action=trophies&userId=ID
  Future<List<Trophy>> getTrophies(int userId) async {
    final response = await _makeRequest(
      action: 'trophies',
      body: {'userId': userId},
    );

    // El API devuelve: {'ok': true, 'data': [...]}
    if (response['ok'] == true && response['data'] != null) {
      final trophiesList = response['data'] as List<dynamic>;
      return trophiesList
          .map((trophy) => Trophy.fromJson(trophy as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['error'] as String? ?? 'Error al cargar trofeos');
    }
  }
}

