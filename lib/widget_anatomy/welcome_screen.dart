import 'package:flutter/material.dart';

import 'product_list_screen.dart';

const _ink = Color(0xFF2F2A5A);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBE9DC),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -50,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0xFFEE7B5F),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(130),
                    bottomLeft: Radius.circular(130),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: -70,
            child: Transform.rotate(
              angle: 0.45,
              child: Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  color: Color(0xFFF6B93B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(95),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(95),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  const Text(
                    'SHOPIN',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 8,
                      color: _ink,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Amazing shopping',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Experience a new way\nof shopping.',
                    style: TextStyle(fontSize: 15, color: _ink.withValues(alpha: 0.6), height: 1.4),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _ink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProductListScreen()),
                      ),
                      child: const Text(
                        'Explore',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
