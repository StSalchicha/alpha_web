import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../providers/content_provider.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar lecciones solo una vez al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      if (contentProvider.lessonsList.length == 0) {
        contentProvider.loadLessons();
      }
    });
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
          'Lecciones',
          style: GoogleFonts.robotoMono(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<ContentProvider>(
        builder: (context, contentProvider, _) {
          // Convertir a lista una sola vez
          final lessons = contentProvider.lessonsList.toList();
          
          if (contentProvider.isLoading && lessons.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          
          if (contentProvider.errorMessage != null && lessons.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contentProvider.errorMessage!,
                    style: GoogleFonts.robotoMono(
                      color: AppColors.danger,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<ContentProvider>(context, listen: false).loadLessons();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          if (lessons.isEmpty) {
            return const Center(
              child: Text('No hay lecciones disponibles'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              
              // Verificar si la lección está desbloqueada usando LinkedList
              final isUnlocked = contentProvider.lessonsList.isLessonUnlocked(lesson.id);
              final isLocked = !isUnlocked;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Opacity(
                  opacity: isLocked ? 0.5 : 1.0,
                  child: GlassCard(
                    onTap: isLocked
                        ? () {
                            // Mostrar SnackBar si intenta acceder a lección bloqueada
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Debes completar la lección anterior',
                                  style: GoogleFonts.robotoMono(),
                                ),
                                backgroundColor: AppColors.danger,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LessonDetailScreen(lessonId: lesson.id),
                              ),
                            );
                          },
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isLocked
                                ? AppColors.textMuted.withOpacity(0.3)
                                : lesson.isCompleted
                                    ? AppColors.success
                                    : AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isLocked
                                ? Icons.lock
                                : lesson.isCompleted
                                    ? Icons.check_circle
                                    : Icons.book,
                            color: isLocked
                                ? AppColors.textMuted
                                : lesson.isCompleted
                                    ? AppColors.background
                                    : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                style: GoogleFonts.robotoMono(
                                  color: isLocked
                                      ? AppColors.textMuted
                                      : AppColors.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLocked
                                    ? 'Bloqueada'
                                    : lesson.isCompleted
                                        ? 'Completada'
                                        : 'Pendiente',
                                style: GoogleFonts.robotoMono(
                                  color: isLocked
                                      ? AppColors.textMuted
                                      : lesson.isCompleted
                                          ? AppColors.success
                                          : AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isLocked ? Icons.lock_outline : Icons.arrow_forward_ios,
                          color: AppColors.textMuted,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

