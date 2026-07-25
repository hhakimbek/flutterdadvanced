import 'package:flutter/material.dart';

import 'lesson_4_1_painters.dart';
import 'lesson_4_2_painters.dart';
import 'lesson_4_3_painters.dart';
import 'lesson_4_lines_painters.dart';

/// Lesson 4 dagi barcha CustomPainter mashqlari uchun menyu.
class ShapesGallery extends StatelessWidget {
  const ShapesGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter — Lesson 4')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Lesson4LinesScreen()),
                ),
                child: const Text('Lesson 4 — Chiziq, plyus, X'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Lesson41Screen()),
                ),
                child: const Text('Lesson 4.1 — Doira, kvadrat, uchburchak'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Lesson42Screen()),
                ),
                child: const Text('Lesson 4.2 — Romb, olti burchak, quti'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Lesson43Screen()),
                ),
                child: const Text('Lesson 4.3 — Silindr, kub, Android'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
