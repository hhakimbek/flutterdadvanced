import 'package:flutter/material.dart';

class Task1Animation extends StatefulWidget {
  const Task1Animation({super.key});

  @override
  State<Task1Animation> createState() => _Task1AnimationState();
}

class _Task1AnimationState extends State<Task1Animation> with TickerProviderStateMixin {
  bool up = false;
  late AnimationController customAnimCtrl;
  late AnimationController buildInExplictCtrl;
  late CurvedAnimation buildInExplictCurveCtrl;
  late Animation<AlignmentGeometry> buildInExplictAnim;
  @override
  void initState() {
    customAnimCtrl = AnimationController(vsync: this);

    buildInExplictCtrl = AnimationController(vsync: this,duration: Duration(milliseconds: 900),);
    buildInExplictCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        buildInExplictCtrl.reverse();
      }
    });
    buildInExplictCurveCtrl = CurvedAnimation(parent: buildInExplictCtrl, curve: Curves.decelerate);
    buildInExplictAnim = AlignmentTween(begin: Alignment.bottomCenter,end: Alignment.topCenter).animate(buildInExplictCurveCtrl);

    super.initState();
  }

  @override
  void dispose() {
    customAnimCtrl.dispose();
    buildInExplictCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SALOM"),
      ),
      body: SafeArea(
        child: Row(
          children: [
            buildInImplictAnim(),
            customImplictAnim(),
            buildInExplict(),
            customInExplict()
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            up = true;
            buildInExplictCtrl.forward();
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

  Widget buildInExplict() {
    return AlignTransition(
      alignment: buildInExplictAnim,
      child: ballWidget(),
    );
  }

  Widget ballWidget() => Image.asset('assets/images/ball.png', width: 100);

  Widget customInExplict() {
    return AnimatedBuilderBall(
      animation: buildInExplictAnim,
      child: ballWidget(),
    );
  }

}


class AnimatedBuilderBall extends StatelessWidget {
  // Bu yerda Alignment o'rniga AlignmentGeometry deb o'zgartiring
  final Animation<AlignmentGeometry> animation;
  final Widget child;

  const AnimatedBuilderBall({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return Align(
          alignment: animation.value,
          child: child,
        );
      },
    );
  }
}