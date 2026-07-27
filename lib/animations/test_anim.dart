import 'package:flutter/material.dart';

class TestAnim extends StatefulWidget {
  const TestAnim({super.key});

  @override
  State<TestAnim> createState() => _TestAnimState();
}

class _TestAnimState extends State<TestAnim> with SingleTickerProviderStateMixin <TestAnim>{

  late AnimationController animationController;
  late Animation<double> animation;
  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(seconds: 2));
    animation = Tween<double>(begin: 0,end: 300).animate(animationController)..addListener(() {
      setState(() {

      });
    },);
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
        child: SizedBox(
          height: animation.value,
          width: animation.value,
          child: FlutterLogo(),
        )
      ),
    );
  }
}
