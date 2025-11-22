import '../../models/question.dart';

class QuestionNode {
  final Question data;
  QuestionNode? next;

  QuestionNode({
    required this.data,
    this.next,
  });
}

class QuestionQueue {
  QuestionNode? _front;
  QuestionNode? _rear;
  int _length = 0;

  int get length => _length;
  bool get isEmpty => _front == null;

  // Enqueue: Agrega una pregunta al final de la cola (FIFO)
  void enqueue(Question question) {
    final newNode = QuestionNode(data: question);
    
    if (_rear == null) {
      _front = _rear = newNode;
    } else {
      _rear!.next = newNode;
      _rear = newNode;
    }
    _length++;
  }

  // Dequeue: Saca la pregunta del frente de la cola
  Question? dequeue() {
    if (_front == null) return null;
    
    final question = _front!.data;
    _front = _front!.next;
    
    if (_front == null) {
      _rear = null;
    }
    _length--;
    return question;
  }

  // Peek: Mira la pregunta del frente sin sacarla
  Question? peek() {
    return _front?.data;
  }

  // Limpia la cola
  void clear() {
    _front = null;
    _rear = null;
    _length = 0;
  }

  // Convierte una lista de preguntas en cola
  void fromList(List<Question> questions) {
    clear();
    for (var question in questions) {
      enqueue(question);
    }
  }
}

