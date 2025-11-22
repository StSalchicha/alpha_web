import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../../providers/content_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import 'menu_screen.dart';

class QuizScreen extends StatefulWidget {
  final int lessonId;

  const QuizScreen({super.key, required this.lessonId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _correctAnswers = 0;
  int _totalQuestions = 0;
  bool _showResult = false;
  int? _selectedAnswerId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentProvider>(context, listen: false)
          .loadQuizForLesson(widget.lessonId);
    });
  }

  void _handleAnswer(int answerId, bool isCorrect) {
    setState(() {
      _selectedAnswerId = answerId;
      if (isCorrect) {
        _correctAnswers++;
      }
      _totalQuestions++;
    });

    // Esperar un momento y luego pasar a la siguiente pregunta usando dequeue()
    Future.delayed(const Duration(milliseconds: 1500), () {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      final questionQueue = contentProvider.questionQueue;

      // Remover la pregunta actual de la cola usando dequeue() (FIFO)
      questionQueue.dequeue();

      if (questionQueue.isEmpty) {
        // Quiz terminado - la cola está vacía
        _finishQuiz();
      } else {
        // Siguiente pregunta disponible en el frente de la cola
        setState(() {
          _selectedAnswerId = null;
        });
      }
    });
  }

  Future<void> _finishQuiz() async {
    setState(() {
      _showResult = true;
    });

    // Guardar resultado en la API
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final userId = authProvider.userData['id'] as int?;
    final quizId = contentProvider.currentQuiz?.id;

    if (userId != null && quizId != null) {
      try {
        await ApiService().saveResult(
          userId: userId,
          quizId: quizId,
          correct: _correctAnswers,
          total: _totalQuestions,
        );
      } catch (e) {
        debugPrint('Error al guardar resultado: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final questionQueue = contentProvider.questionQueue;
    // Usar peek() para mostrar la pregunta actual sin removerla de la cola
    final currentQuestion = questionQueue.peek();

    if (contentProvider.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_showResult) {
      final percentage = (_correctAnswers / _totalQuestions * 100).round();
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: GlassCard(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      percentage >= 70 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                      size: 80,
                      color: percentage >= 70 ? AppColors.success : AppColors.danger,
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    Text(
                      'Quiz Completado',
                      style: GoogleFonts.robotoMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Puntuación: $_correctAnswers / $_totalQuestions',
                      style: GoogleFonts.robotoMono(
                        fontSize: 24,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$percentage%',
                      style: GoogleFonts.robotoMono(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: percentage >= 70 ? AppColors.success : AppColors.danger,
                      ),
                    ),
                    const SizedBox(height: 32),
                    NeonButton(
                      text: 'VOLVER AL MENÚ',
                      onPressed: () {
                        contentProvider.clearQuiz();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const MenuScreen()),
                          (route) => false,
                        );
                      },
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (currentQuestion == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: Text('No hay preguntas disponibles'),
        ),
      );
    }

    // Debug: verificar que las respuestas estén cargadas
    if (currentQuestion.answers.isEmpty) {
      debugPrint('ADVERTENCIA: La pregunta "${currentQuestion.text}" no tiene respuestas');
      debugPrint('Total de preguntas en el quiz: ${questionQueue.length}');
      debugPrint('Quiz ID: ${contentProvider.currentQuiz?.id}');
      debugPrint('Pregunta ID: ${currentQuestion.id}');
      debugPrint('Pregunta quizId: ${currentQuestion.quizId}');
      
      // Intentar recargar el quiz
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ContentProvider>(context, listen: false)
            .loadQuizForLesson(widget.lessonId);
      });
      
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 64),
              const SizedBox(height: 16),
              Text(
                'Esta pregunta no tiene respuestas disponibles',
                style: GoogleFonts.robotoMono(
                  color: AppColors.text,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Recargando...',
                style: GoogleFonts.robotoMono(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
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
          'Cuestionario',
          style: GoogleFonts.robotoMono(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Indicador de progreso
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pregunta ${_totalQuestions + 1} de ${questionQueue.length + _totalQuestions}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Barra de progreso
                    Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (_totalQuestions + 1) / (questionQueue.length + _totalQuestions),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Pregunta
              GlassCard(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.secondary.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Pregunta',
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion.text
                          .replaceAll('\\n', '\n')
                          .replaceAll(r'\n', '\n'),
                      style: GoogleFonts.robotoMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Título de sección de respuestas
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Selecciona una respuesta:',
                  style: GoogleFonts.robotoMono(
                    fontSize: 14,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Respuestas - Estilo Google Forms
              ...List.generate(
                currentQuestion.answers.length,
                (index) {
                    final answer = currentQuestion.answers[index];
                    final isSelected = _selectedAnswerId == answer.id;
                    final isCorrect = answer.isCorrect;
                    final showResult = _selectedAnswerId != null;

                    // Colores y estilos según el estado
                    Color borderColor = AppColors.textMuted.withOpacity(0.3);
                    Color backgroundColor = Colors.transparent;
                    Color textColor = AppColors.text;
                    
                    if (isSelected) {
                      borderColor = isCorrect ? AppColors.success : AppColors.danger;
                      backgroundColor = (isCorrect ? AppColors.success : AppColors.danger).withOpacity(0.1);
                    } else if (showResult && isCorrect) {
                      borderColor = AppColors.success;
                      backgroundColor = AppColors.success.withOpacity(0.1);
                    } else if (!showResult) {
                      // Efecto hover cuando no hay resultado
                      borderColor = AppColors.primary.withOpacity(0.3);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _selectedAnswerId == null
                              ? () => _handleAnswer(answer.id, answer.isCorrect)
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: borderColor,
                                width: showResult && (isSelected || isCorrect) ? 2.5 : 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isSelected && !showResult
                                  ? [
                                      BoxShadow(
                                        color: borderColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Radio button visual
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? borderColor : AppColors.textMuted.withOpacity(0.5),
                                      width: 2.5,
                                    ),
                                    color: isSelected
                                        ? borderColor.withOpacity(0.2)
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: borderColor,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                // Texto de la respuesta
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        answer.text
                                            .replaceAll('\\n', '\n')
                                            .replaceAll(r'\n', '\n'),
                                        style: GoogleFonts.robotoMono(
                                          fontSize: 16,
                                          color: textColor,
                                          height: 1.5,
                                        ),
                                      ),
                                      // Indicador de resultado
                                      if (showResult) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              isSelected
                                                  ? (isCorrect ? Icons.check_circle : Icons.cancel)
                                                  : (isCorrect ? Icons.check_circle_outline : null),
                                              size: 18,
                                              color: isSelected
                                                  ? (isCorrect ? AppColors.success : AppColors.danger)
                                                  : AppColors.success,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              isSelected
                                                  ? (isCorrect ? 'Correcta' : 'Incorrecta')
                                                  : (isCorrect ? 'Respuesta correcta' : ''),
                                              style: GoogleFonts.robotoMono(
                                                fontSize: 14,
                                                color: isSelected
                                                    ? (isCorrect ? AppColors.success : AppColors.danger)
                                                    : AppColors.success,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .animate(target: isSelected ? 1 : 0)
                          .scale(duration: 200.ms, begin: const Offset(0.98, 0.98))
                          .then()
                          .shake(duration: isSelected && !isCorrect ? 300.ms : 0.ms),
                    );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

