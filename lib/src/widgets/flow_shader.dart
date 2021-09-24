import 'package:flutter/material.dart';

class FlowShader extends StatefulWidget {
  const FlowShader({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.direction = Axis.horizontal,
  }) : super(key: key);

  final Widget child;
  final Axis direction;
  final Duration duration;

  @override
  _FlowShaderState createState() => _FlowShaderState();
}

class _FlowShaderState extends State<FlowShader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation1;
  late Animation animation2;
  late Animation animation3;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation1 = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.black, end: Colors.white),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.white, end: Colors.black),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.45, curve: Curves.linear),
      ),
    );
    animation2 = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.black, end: Colors.white),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.white, end: Colors.black),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.15, 0.75, curve: Curves.linear),
      ),
    );
    animation3 = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.black, end: Colors.white),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.white, end: Colors.black),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.45, 1, curve: Curves.linear),
      ),
    );
    controller.repeat();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          colors: [
            animation3.value,
            animation2.value,
            animation1.value,
          ],
          begin: widget.direction == Axis.horizontal
              ? Alignment.centerLeft
              : Alignment.topCenter,
          end: widget.direction == Axis.horizontal
              ? Alignment.centerRight
              : Alignment.bottomCenter,
        ).createShader(rect);
      },
      child: widget.child,
    );
  }
}
