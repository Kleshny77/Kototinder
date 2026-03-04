import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedAuthBackground extends StatefulWidget {
  const AnimatedAuthBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedAuthBackground> createState() => _AnimatedAuthBackgroundState();
}

class _AnimatedAuthBackgroundState extends State<AnimatedAuthBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _catController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _catController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _catController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            final t = _gradientController.value;
            final dx = 0.15 * math.sin(t * math.pi);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.0 + dx, -1.0),
                  end: Alignment(1.0 - dx, 1.0),
                  colors: [
                    Colors.deepPurple.shade400,
                    Colors.purple.shade300,
                    Colors.purple.shade200,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.of(context).size.height * 0.22,
          child: AnimatedBuilder(
            animation: _catController,
            builder: (context, _) {
              final y = 8.0 * math.sin(_catController.value * math.pi);
              return Transform.translate(
                offset: Offset(0, y),
                child: const Center(
                  child: Text('🐱', style: TextStyle(fontSize: 64)),
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}
