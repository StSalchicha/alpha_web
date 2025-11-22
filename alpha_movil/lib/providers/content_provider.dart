import 'package:flutter/foundation.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';
import '../services/api_service.dart';
import '../utils/structures/lesson_linked_list.dart';
import '../utils/structures/lesson_node.dart';
import '../utils/structures/question_queue.dart';

class ContentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LessonLinkedList _lessonsList = LessonLinkedList();
  final QuestionQueue _questionQueue = QuestionQueue();

  bool _isLoading = false;
  String? _errorMessage;
  Quiz? _currentQuiz;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LessonLinkedList get lessonsList => _lessonsList;
  QuestionQueue get questionQueue => _questionQueue;
  Quiz? get currentQuiz => _currentQuiz;

  // Cargar todas las lecciones desde la API e insertarlas en la LinkedList
  Future<void> loadLessons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lessons = await _apiService.getLessons();
      
      // Limpiar la lista y cargar las nuevas lecciones
      _lessonsList.clear();
      for (var lesson in lessons) {
        _lessonsList.append(lesson);
      }

      // Resetear al inicio
      _lessonsList.reset();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar detalle de una lección específica
  Future<Lesson?> loadLessonDetail(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final lesson = await _apiService.getLessonDetail(lessonId);
      
      // Actualizar la lección en la LinkedList con el contenido HTML completo
      final node = _lessonsList.findById(lessonId);
      if (node != null) {
        node.data.contentHtml = lesson.contentHtml;
      }

      _isLoading = false;
      notifyListeners();
      return lesson;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Cargar quiz de una lección y meterlo en la Queue
  Future<void> loadQuizForLesson(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final quiz = await _apiService.getQuizByLesson(lessonId);
      _currentQuiz = quiz;

      // Limpiar la cola y cargar las preguntas
      _questionQueue.clear();
      _questionQueue.fromList(quiz.questions);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marcar una lección como completada
  void markLessonAsCompleted(int lessonId) {
    final node = _lessonsList.findById(lessonId);
    if (node != null) {
      node.data.isCompleted = true;
      notifyListeners();
    }
  }

  // Limpiar el quiz actual
  void clearQuiz() {
    _questionQueue.clear();
    _currentQuiz = null;
    notifyListeners();
  }

  // Obtener la siguiente lección después de la actual (usando LinkedList)
  // Retorna el nodo siguiente si existe, null si no hay siguiente
  LessonNode? getNextLesson(int currentLessonId) {
    final currentNode = _lessonsList.findById(currentLessonId);
    if (currentNode != null) {
      return currentNode.next;
    }
    return null;
  }

  // Obtener la lección siguiente como objeto Lesson (helper para UI)
  Lesson? getNextLessonData(int currentLessonId) {
    final nextNode = getNextLesson(currentLessonId);
    return nextNode?.data;
  }
}

