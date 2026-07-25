import 'package:flutter/material.dart';

/// Ekranda ko'rsatiladigan bitta shakl.
class ShapeItem {
  const ShapeItem({
    required this.label,
    required this.painter,
    this.size = const Size(170, 170),
  });

  final String label;
  final CustomPainter painter;
  final Size size;
}

/// Shakllarni ekranda ketma-ket chizadigan oddiy ekran.
class ShapesShowcase extends StatelessWidget {
  const ShapesShowcase({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ShapeItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          children: [
            for (final item in items) ...[
              CustomPaint(size: item.size, painter: item.painter),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }
}
