import '../../models/lesson.dart';

class LessonNode {
  final Lesson data;
  LessonNode? next;

  LessonNode({
    required this.data,
    this.next,
  });
}

