import 'question.dart';

class Quiz {
  final int id;
  final int lessonId;
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int? ?? 0,
      lessonId: json['lessonId'] as int? ?? json['lesson_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((question) => Question.fromJson(question as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}

