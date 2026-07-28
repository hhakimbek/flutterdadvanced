import 'package:flutter/material.dart';

class Task1Animation extends StatefulWidget {
  const Task1Animation({super.key});

  @override
  State<Task1Animation> createState() => _Task1AnimationState();
}

class _Task1AnimationState extends State<Task1Animation>
    with TickerProviderStateMixin {
  bool up = false;

  late AnimationController customAnimCtrl;

  @override
  void initState() {
    customAnimCtrl = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    customAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            buildInImplictAnim(),
            customImplictAnim(),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            up = true;
          });
        },
      ),
    );
  }

  Widget buildInImplictAnim() {
    return AnimatedAlign(
      curve: up ? Curves.decelerate : Curves.bounceOut,
      alignment: up
          ? AlignmentGeometry.topCenter
          : Alignment.bottomCenter,
      duration: up
          ? Duration(milliseconds: 700)
          : Duration(milliseconds: 1300),
      onEnd: () {
        setState(() {
          up = false;
        });
      },
      child: ballWidget(),
    );
  }

  Widget customImplictAnim() {
    return TweenAnimationBuilder<Alignment>(
      curve: Curves.bounceOut,
      onEnd: () {
        setState(() {
          up = false;
        });
      },
      tween: AlignmentTween(
        begin: up ? Alignment.bottomCenter : Alignment.topCenter,
        end: up ? Alignment.topCenter : Alignment.bottomCenter,
      ),
      duration: Duration(milliseconds: 1200),
      child: ballWidget(),
      builder: (context, value, child) {
        return Align(alignment: value, child: child);
      },
    );
  }

  Widget ballWidget() => Image.asset('assets/images/ball.png', width: 100);
}
