import 'package:flutter/material.dart';

import 'app_style.dart';
import 'phone_number_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TolkiColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const TolkiLogo(centered: true),
              const Spacer(flex: 2),
              const _ChatIllustration(),
              const Spacer(flex: 2),
              const Text(
                "Let's start the chat!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: TolkiColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Connect with friends and family securely\nand private, enjoy!',
                textAlign: TextAlign.center,
                style: TolkiText.subtitle,
              ),
              const Spacer(flex: 2),
              TolkiButton(
                text: 'Get started',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PhoneNumberScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatIllustration extends StatelessWidget {
  const _ChatIllustration();

  @override
  Widget build(BuildContext context) {
    final emojis = ['😀', '😂', '😍', '😎', '🥳', '😅', '🤗', '😉'];
    return SizedBox(
      height: 280,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (int i = 0; i < emojis.length; i++)
            Align(
              alignment: Alignment(
                1.05 * _cos(i, emojis.length),
                1.05 * _sin(i, emojis.length),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TolkiColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  emojis[i],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              color: TolkiColors.primaryDark,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: TolkiColors.primary.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _Bubble(alignEnd: false),
                  SizedBox(height: 12),
                  _Bubble(alignEnd: true),
                  SizedBox(height: 12),
                  _Bubble(alignEnd: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _cos(int i, int n) {
    const table = [1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071, 0.0, 0.7071];
    return table[i % n];
  }

  double _sin(int i, int n) {
    const table = [0.0, 0.7071, 1.0, 0.7071, 0.0, -0.7071, -1.0, -0.7071];
    return table[i % n];
  }
}

class _Bubble extends StatelessWidget {
  final bool alignEnd;
  const _Bubble({required this.alignEnd});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 80,
        height: 22,
        decoration: BoxDecoration(
          color: alignEnd ? TolkiColors.primary : Colors.white24,
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }
}
