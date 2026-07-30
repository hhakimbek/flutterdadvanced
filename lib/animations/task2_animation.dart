import 'package:flutter/material.dart';
import 'dart:math' as math;

class Task2Anim extends StatefulWidget {
  const Task2Anim({Key? key}) : super(key: key);

  @override
  State<Task2Anim> createState() => _Task2AnimState();
}

class _Task2AnimState extends State<Task2Anim> with TickerProviderStateMixin {

  late final AnimationController _rotationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _curvedAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOutBack,
  );

  double _implicitSize = 60.0;
  bool _isBig = false;

  Color _implicitColor = Colors.red;
  final List<Color> _colors = [Colors.red, Colors.pink, Colors.orange, Colors.purple];
  int _colorIndex = 0;

  @override
  void dispose() {
    // Controllerlarni xotiradan tozalash shart
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleImplicitSize() {
    setState(() {
      _implicitSize = _isBig ? 60.0 : 100.0;
      _isBig = !_isBig;
    });
  }

  void _changeImplicitColor() {
    setState(() {
      _colorIndex = (_colorIndex + 1) % _colors.length;
      _implicitColor = _colors[_colorIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yurakcha Animatsiyalari"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Build-In Implicit Animation (AnimatedContainer)
              _buildSectionTitle("1. Build-In Implicit (AnimatedContainer)"),
              const Text("Yurak ustiga bosing (Size Change)"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _toggleImplicitSize,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    width: _implicitSize,
                    height: _implicitSize,
                    child: const Icon(Icons.favorite, color: Colors.red, size: 100),
                  ),
                ),
              ),
              const Divider(height: 40),

              // 2. Custom Implicit Animation (TweenAnimationBuilder)
              _buildSectionTitle("2. Custom Implicit (TweenAnimationBuilder)"),
              const Text("Rang o'zgarishi (Color Change)"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _changeImplicitColor,
                child: const Text("Rangni o'zgartir"),
              ),
              const SizedBox(height: 10),
              Center(
                child: TweenAnimationBuilder<Color?>(
                  tween: ColorTween(begin: Colors.grey, end: _implicitColor),
                  duration: const Duration(seconds: 1),
                  builder: (context, color, child) {
                    return Icon(
                      Icons.favorite,
                      color: color ?? Colors.red,
                      size: 100,
                    );
                  },
                ),
              ),
              const Divider(height: 40),

              // 3. Build-In Explicit Animation (RotationTransition)
              _buildSectionTitle("3. Build-In Explicit (RotationTransition)"),
              const Text("Doimiy aylanish"),
              const SizedBox(height: 10),
              Center(
                child: RotationTransition(
                  turns: _rotationController,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.green,
                    size: 100,
                  ),
                ),
              ),
              const Divider(height: 40),

              // 4. Custom Explicit Animation (ScaleTransition + CurvedAnimation)
              _buildSectionTitle("4. Custom Explicit (ScaleTransition + Pulse)"),
              const Text("Yurak urishi (Pulse)"),
              const SizedBox(height: 10),
              Center(
                child: ScaleTransition(
                  // CurvedAnimation yordamida pulse effekti tabiiyroq chiqadi
                  scale: _curvedAnimation,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.blue,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 30), // Pastda joy qoldirish uchun
            ],
          ),
        ),
      ),
      // Animatsiyalarni to'xtatish/boshlash uchun Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          if (_rotationController.isAnimating) {
            _rotationController.stop();
            _scaleController.stop();
          } else {
            _rotationController.repeat();
            _scaleController.repeat(reverse: true);
          }
        },
        child: Icon(Icons.play_arrow_rounded),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}

