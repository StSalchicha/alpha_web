import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;
    final trophies = authProvider.trophies;

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
          'Perfil',
          style: GoogleFonts.robotoMono(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información del usuario
            GlassCard(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.3),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData['name'] ?? 'Usuario',
                    style: GoogleFonts.robotoMono(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userData['email'] ?? '',
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Trofeos
            Text(
              'Trofeos',
              style: GoogleFonts.robotoMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            if (trophies.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Aún no has ganado trofeos. ¡Completa lecciones y cuestionarios para desbloquearlos!',
                  style: GoogleFonts.robotoMono(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...trophies.map((trophy) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: trophy.awardedAt != null
                                ? AppColors.success
                                : AppColors.textMuted,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trophy.title,
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: trophy.awardedAt != null
                                        ? AppColors.text
                                        : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  trophy.description,
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                if (trophy.awardedAt != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Obtenido: ${trophy.awardedAt!.day}/${trophy.awardedAt!.month}/${trophy.awardedAt!.year}',
                                    style: GoogleFonts.robotoMono(
                                      fontSize: 10,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 32),

            // Botón de logout
            NeonButton(
              text: 'CERRAR SESIÓN',
              onPressed: () async {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              color: AppColors.danger,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

