import 'dart:math';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget frontSide;
  final Widget backSide;
  final Duration duration;
  final Curve curve;
  final double elevation;
  final BorderRadius? borderRadius;
  final bool autoFlipOnInit;

  const FlipCard({
    super.key,
    required this.frontSide,
    required this.backSide,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.elevation = 8.0,
    this.borderRadius,
    this.autoFlipOnInit = false,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Auto flip once on init if enabled
    if (widget.autoFlipOnInit) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _controller.reverse().then((_) {
              _isFront = true;
            });
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(angle);

          // Determine which side to show
          final showFront = angle < pi / 2;

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: widget.elevation * 2,
                    offset: Offset(0, widget.elevation),
                  ),
                ],
              ),
              child: showFront
                  ? widget.frontSide
                  : Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: widget.backSide,
                    ),
            ),
          );
        },
      ),
    );
  }
}
