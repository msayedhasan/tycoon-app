import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with TickerProviderStateMixin {
  AnimationController? animation;
  Animation<double>? _fadeIn;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.delay.toInt()),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 0.5).animate(animation!);

    animation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animation!.forward();
      }
    });
    animation!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: widget.child,
    );
  }
}
