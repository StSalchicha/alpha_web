import 'lesson_node.dart';
import '../../models/lesson.dart';

class LessonLinkedList {
  LessonNode? _head;
  LessonNode? _current;
  int _length = 0;

  int get length => _length;
  LessonNode? get head => _head;
  LessonNode? get current => _current;

  // Inserta una lección al final de la lista
  void append(Lesson lesson) {
    final newNode = LessonNode(data: lesson);
    
    if (_head == null) {
      _head = newNode;
      _current = _head;
    } else {
      LessonNode? temp = _head;
      while (temp!.next != null) {
        temp = temp.next;
      }
      temp.next = newNode;
    }
    _length++;
  }

  // Inserta una lección al inicio de la lista
  void prepend(Lesson lesson) {
    final newNode = LessonNode(data: lesson, next: _head);
    _head = newNode;
    if (_current == null) {
      _current = _head;
    }
    _length++;
  }

  // Busca una lección por ID
  LessonNode? findById(int id) {
    LessonNode? temp = _head;
    while (temp != null) {
      if (temp.data.id == id) {
        return temp;
      }
      temp = temp.next;
    }
    return null;
  }

  // Mueve al siguiente nodo
  bool moveNext() {
    if (_current?.next != null) {
      _current = _current!.next;
      return true;
    }
    return false;
  }

  // Mueve al nodo anterior (requiere recorrer desde el inicio)
  bool movePrevious() {
    if (_head == null || _current == null) return false;
    
    if (_current == _head) return false; // Ya está en el inicio
    
    LessonNode? temp = _head;
    while (temp != null && temp.next != _current) {
      temp = temp.next;
    }
    
    if (temp != null) {
      _current = temp;
      return true;
    }
    return false;
  }

  // Resetea al inicio
  void reset() {
    _current = _head;
  }

  // Verifica si puede avanzar (la lección actual debe estar completada)
  bool canMoveNext() {
    if (_current == null) return false;
    if (_current!.next == null) return false;
    return _current!.data.isCompleted;
  }

  // Obtiene todas las lecciones como lista (para mostrar en UI)
  List<Lesson> toList() {
    List<Lesson> lessons = [];
    LessonNode? temp = _head;
    while (temp != null) {
      lessons.add(temp.data);
      temp = temp.next;
    }
    return lessons;
  }

  // Limpia la lista
  void clear() {
    _head = null;
    _current = null;
    _length = 0;
  }

  // Obtiene el nodo anterior a uno dado (requiere recorrer desde el inicio)
  LessonNode? getPreviousNode(int lessonId) {
    if (_head == null) return null;
    
    // Si es el head, no tiene anterior
    if (_head!.data.id == lessonId) return null;
    
    LessonNode? temp = _head;
    while (temp != null && temp.next != null) {
      if (temp.next!.data.id == lessonId) {
        return temp;
      }
      temp = temp.next;
    }
    return null;
  }

  // Verifica si una lección está desbloqueada
  // Una lección está desbloqueada si:
  // 1. Es la primera (head) O
  // 2. La lección anterior está completada
  bool isLessonUnlocked(int lessonId) {
    final currentNode = findById(lessonId);
    if (currentNode == null) return false;
    
    // Si es el head, está desbloqueada
    if (currentNode == _head) return true;
    
    // Si no es el head, verificar que la anterior esté completada
    final previousNode = getPreviousNode(lessonId);
    if (previousNode == null) return false;
    
    return previousNode.data.isCompleted;
  }
}

