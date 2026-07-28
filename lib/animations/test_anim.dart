import 'package:flutter/material.dart';

class TestAnim extends StatefulWidget {
  const TestAnim({super.key});

  @override
  State<TestAnim> createState() => _TestAnimState();
}

class _TestAnimState extends State<TestAnim>
    with SingleTickerProviderStateMixin<TestAnim> {
  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceOut,
    );
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyAnim(animation: curvedAnimation, child: Text("SALOM")),
      ),
    );
  }
}

class MyAnim extends AnimatedWidget {
  final Widget? child;

  const MyAnim({super.key, required Animation<double> animation, this.child})
    : super(listenable: animation);

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: SizedBox(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        child: TweenAnimationBuilder(
          tween: ColorTween(begin: Colors.white, end: Colors.yellow),
          duration: Duration(seconds: 2),
          child: FlutterLogo(),
          builder: (context, value, child) {
            return ColorFiltered(colorFilter: ColorFilter.mode(value!, BlendMode.modulate),child: child,);
          },
        ),
      ),
    );
  }
}
