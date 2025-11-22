class Lesson {
  final int id;
  final String title;
  String contentHtml;
  final bool isActive;
  bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.contentHtml,
    required this.isActive,
    this.isCompleted = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as int,
      title: json['title'] as String,
      contentHtml: json['content_html'] as String? ?? json['contentHtml'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      isCompleted: json['isCompleted'] as bool? ?? json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content_html': contentHtml,
      'isActive': isActive,
      'isCompleted': isCompleted,
    };
  }
}

