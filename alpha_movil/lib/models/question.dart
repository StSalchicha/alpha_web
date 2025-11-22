import 'package:flutter/foundation.dart';
import 'answer.dart';

class Question {
  final int id;
  final int quizId;
  final String text;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.quizId,
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final answersList = (json['answers'] as List<dynamic>?);
    final text = json['text']?.toString() ?? 'sin texto';
    final textPreview = text.length > 30 ? text.substring(0, 30) : text;
    debugPrint('Question.fromJson: id=${json['id']}, text=$textPreview, answers count=${answersList?.length ?? 0}');
    if (answersList != null) {
      for (var i = 0; i < answersList.length; i++) {
        final ans = answersList[i];
        debugPrint('  Answer $i: ${ans}');
      }
    }
    return Question(
      id: json['id'] as int? ?? 0,
      quizId: json['quizId'] as int? ?? json['quiz_id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      answers: answersList
              ?.map((answer) {
                try {
                  return Answer.fromJson(answer as Map<String, dynamic>);
                } catch (e) {
                  debugPrint('Error al parsear respuesta: $e, datos: $answer');
                  return null;
                }
              })
              .whereType<Answer>()
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'text': text,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

