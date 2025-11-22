import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class NeonTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const NeonTextField({
    super.key,
    this.label,
    this.hint,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  State<NeonTextField> createState() => _NeonTextFieldState();
}

class _NeonTextFieldState extends State<NeonTextField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.label!,
                style: GoogleFonts.robotoMono(
                  color: AppColors.text,
                  fontSize: 14,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hasFocus ? AppColors.primary : Colors.white.withOpacity(0.1),
                width: _hasFocus ? 2 : 1,
              ),
              boxShadow: _hasFocus
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              style: GoogleFonts.robotoMono(
                color: AppColors.text,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.robotoMono(
                  color: AppColors.textMuted,
                  fontSize: 16,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

