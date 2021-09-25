import 'package:flutter/material.dart';

class FlowShader extends StatefulWidget {
  const FlowShader({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.direction = Axis.horizontal,
    this.flowColors = const <Color>[Colors.white, Colors.black],
  })  : assert(flowColors.length == 2),
        super(key: key);

  final Widget child;
  final Axis direction;
  final Duration duration;
  final List<Color> flowColors;

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final TweenSequenceItem seqbw = TweenSequenceItem(
      tween: ColorTween(
        begin: widget.flowColors.last,
        end: widget.flowColors.first,
      ),
      weight: 1,
    );
    final TweenSequenceItem seqwb = TweenSequenceItem(
      tween: ColorTween(
        begin: widget.flowColors.first,
        end: widget.flowColors.last,
      ),
      weight: 1,
    );
    animation1 = TweenSequence([seqbw, seqwb]).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.45, curve: Curves.linear),
      ),
    );
    animation2 = TweenSequence([seqbw, seqwb]).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.15, 0.75, curve: Curves.linear),
      ),
    );
    animation3 = TweenSequence([seqbw, seqwb]).animate(
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
