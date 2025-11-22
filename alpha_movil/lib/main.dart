import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/theme/app_colors.dart';
import 'providers/auth_provider.dart';
import 'providers/content_provider.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/menu_screen.dart';

void main() {
  runApp(const MouseFlowApp());
}

class MouseFlowApp extends StatelessWidget {
  const MouseFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
      ],
      child: MaterialApp(
        title: 'MouseFlow',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.background,
            error: AppColors.danger,
            onPrimary: AppColors.background,
            onSecondary: AppColors.background,
            onSurface: AppColors.text,
            onError: AppColors.text,
          ),
          textTheme: GoogleFonts.robotoMonoTextTheme(
            ThemeData.dark().textTheme,
          ).apply(
            bodyColor: AppColors.text,
            displayColor: AppColors.text,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.text),
            titleTextStyle: GoogleFonts.robotoMono(
              color: AppColors.text,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.danger,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.danger,
                width: 2,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoading) {
              return const Scaffold(
                backgroundColor: AppColors.background,
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }
            return authProvider.isAuthenticated
                ? const MenuScreen()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}
