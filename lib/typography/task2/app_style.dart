import 'package:flutter/material.dart';

class TolkiColors {
  static const primary = Color(0xFF6C5CE7);
  static const primaryDark = Color(0xFF1A1A2E);
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF8E8EA9);
  static const hint = Color(0xFFB6B6C7);
  static const fieldBorder = Color(0xFFE8E8F0);
  static const otpEmpty = Color(0xFFECECF3);
  static const keyboard = Color(0xFFD7D9E0);
}

class TolkiText {
  static const logo = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: TolkiColors.primaryDark,
  );
  static const heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: TolkiColors.textPrimary,
    height: 1.25,
  );
  static const subtitle = TextStyle(
    fontSize: 14,
    color: TolkiColors.textSecondary,
    height: 1.5,
  );
}

class TolkiLogo extends StatelessWidget {
  final bool centered;
  const TolkiLogo({super.key, this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: TolkiColors.primary,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.chat_bubble_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        const Text('Tolki', style: TolkiText.logo),
      ],
    );
  }
}

class TolkiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  const TolkiButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: TolkiColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: TolkiColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
