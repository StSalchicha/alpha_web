import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../../providers/content_provider.dart';
import 'quiz_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final int lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentProvider>(context, listen: false)
          .loadLessonDetail(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final lessonNode = contentProvider.lessonsList.findById(widget.lessonId);
    final lesson = lessonNode?.data;

    if (lesson == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

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
          lesson.title,
          style: GoogleFonts.robotoMono(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: contentProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(24.0),
                    child: lesson.contentHtml.isEmpty
                        ? Column(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 48,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Esta lección aún no tiene contenido',
                                style: GoogleFonts.robotoMono(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : Html(
                            data: lesson.contentHtml,
                            style: {
                              'body': Style(
                                color: AppColors.text,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontSize: FontSize(16),
                                lineHeight: const LineHeight(1.6),
                              ),
                              'h1': Style(
                                color: AppColors.primary,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontSize: FontSize(24),
                                fontWeight: FontWeight.bold,
                              ),
                              'h2': Style(
                                color: AppColors.secondary,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontSize: FontSize(20),
                                fontWeight: FontWeight.bold,
                              ),
                              'h3': Style(
                                color: AppColors.primary,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontSize: FontSize(18),
                                fontWeight: FontWeight.bold,
                              ),
                              'p': Style(
                                color: AppColors.text,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontSize: FontSize(16),
                                lineHeight: const LineHeight(1.6),
                              ),
                              'ul': Style(
                                color: AppColors.text,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                              ),
                              'li': Style(
                                color: AppColors.text,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                                fontSize: FontSize(16),
                              ),
                              'code': Style(
                                backgroundColor: Colors.black.withOpacity(0.3),
                                color: AppColors.secondary,
                                fontFamily: GoogleFonts.robotoMono().fontFamily,
                              ),
                            },
                          ),
                  ),
                  const SizedBox(height: 24),
                  NeonButton(
                    text: 'IR AL CUESTIONARIO',
                    onPressed: () {
                      // Marcar lección como completada
                      contentProvider.markLessonAsCompleted(widget.lessonId);
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(lessonId: widget.lessonId),
                        ),
                      );
                    },
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  // Usar getNextLesson() de ContentProvider (usa LinkedList)
                  Builder(
                    builder: (context) {
                      final nextLessonNode = contentProvider.getNextLesson(widget.lessonId);
                      final canMoveNext = nextLessonNode != null && lesson?.isCompleted == true;
                      
                      if (canMoveNext) {
                        return NeonButton(
                          text: 'SIGUIENTE LECCIÓN',
                          onPressed: () {
                            final nextLesson = contentProvider.getNextLessonData(widget.lessonId);
                            if (nextLesson != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => LessonDetailScreen(lessonId: nextLesson.id),
                                ),
                              );
                            }
                          },
                          color: AppColors.secondary,
                          width: double.infinity,
                        );
                      } else {
                        // Mostrar mensaje si no puede avanzar
                        return GlassCard(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Completa esta lección para desbloquear la siguiente',
                            style: GoogleFonts.robotoMono(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

