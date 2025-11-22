import 'package:flutter/foundation.dart';

class Answer {
  final int id;
  final int questionId;
  final String text;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.questionId,
    required this.text,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    try {
      final id = json['id'];
      final questionId = json['questionId'] ?? json['question_id'];
      final text = json['text'];
      final isCorrect = json['isCorrect'] ?? json['is_correct'];
      
      debugPrint('Answer.fromJson: id=$id (${id.runtimeType}), questionId=$questionId (${questionId.runtimeType}), text=$text, isCorrect=$isCorrect (${isCorrect.runtimeType})');
      
      return Answer(
        id: (id is int) ? id : (id is num) ? id.toInt() : 0,
        questionId: (questionId is int) ? questionId : (questionId is num) ? questionId.toInt() : 0,
        text: (text is String) ? text : text?.toString() ?? '',
        isCorrect: (isCorrect is bool) ? isCorrect : (isCorrect == 1 || isCorrect == true || isCorrect == 'true'),
      );
    } catch (e, stackTrace) {
      debugPrint('Error al parsear Answer: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('JSON recibido: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionId': questionId,
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}

