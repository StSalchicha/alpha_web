import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../providers/content_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/lesson.dart';
import '../../models/quiz.dart';
import 'quiz_screen.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  List<Map<String, dynamic>> _quizzesWithLessons = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      final apiService = ApiService();
      
      // Cargar todas las lecciones
      final lessons = await apiService.getLessons();
      final quizzesList = <Map<String, dynamic>>[];

      // Para cada lección, intentar cargar su quiz
      for (var lesson in lessons) {
        try {
          final quiz = await apiService.getQuizByLesson(lesson.id);
          if (quiz.questions.isNotEmpty) {
            quizzesList.add({
              'lesson': lesson,
              'quiz': quiz,
            });
          } else {
            debugPrint('Quiz de lección ${lesson.id} no tiene preguntas');
          }
        } catch (e) {
          // Si no hay quiz para esta lección, simplemente no la agregamos
          debugPrint('No hay quiz para lección ${lesson.id} (${lesson.title}): $e');
        }
      }
      
      debugPrint('Total de quizzes encontrados: ${quizzesList.length}');

      setState(() {
        _quizzesWithLessons = quizzesList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cuestionarios',
          style: GoogleFonts.robotoMono(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: GoogleFonts.robotoMono(
                          color: AppColors.danger,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadQuizzes,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _quizzesWithLessons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.quiz_outlined,
                            size: 64,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay cuestionarios disponibles',
                            style: GoogleFonts.robotoMono(
                              color: AppColors.textMuted,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _quizzesWithLessons.length,
                      itemBuilder: (context, index) {
                        final item = _quizzesWithLessons[index];
                        final lesson = item['lesson'] as Lesson;
                        final quiz = item['quiz'] as Quiz;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GlassCard(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => QuizScreen(lessonId: lesson.id),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.quiz,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            quiz.title,
                                            style: GoogleFonts.robotoMono(
                                              color: AppColors.text,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Lección: ${lesson.title}',
                                            style: GoogleFonts.robotoMono(
                                              color: AppColors.textMuted,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.textMuted,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${quiz.questions.length} pregunta${quiz.questions.length != 1 ? 's' : ''}',
                                    style: GoogleFonts.robotoMono(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

