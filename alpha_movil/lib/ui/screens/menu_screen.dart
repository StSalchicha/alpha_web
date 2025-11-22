import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/content_provider.dart';
import 'lessons_screen.dart';
import 'quizzes_screen.dart';
import 'profile_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOUSEFLOW',
                        style: GoogleFonts.robotoMono(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bienvenido, ${authProvider.userData['name'] ?? 'Usuario'}',
                        style: GoogleFonts.robotoMono(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.person,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Botones de navegación
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    GlassCard(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: 64,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lecciones',
                            style: GoogleFonts.robotoMono(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aprende sobre programación',
                            style: GoogleFonts.robotoMono(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 24),
                          NeonButton(
                            text: 'VER LECCIONES',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const LessonsScreen(),
                                ),
                              );
                            },
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassCard(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.quiz,
                            size: 64,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Cuestionarios',
                            style: GoogleFonts.robotoMono(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pon a prueba tus conocimientos',
                            style: GoogleFonts.robotoMono(
                              fontSize: 14,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 24),
                          NeonButton(
                            text: 'VER CUESTIONARIOS',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QuizzesScreen(),
                                ),
                              );
                            },
                            color: AppColors.secondary,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

