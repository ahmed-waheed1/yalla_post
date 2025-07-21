import 'package:flutter/material.dart';

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: 165 * 3.14159 / 180,
              child: Stack(
                children: [
                  Positioned(
                    top: 20 - 4,
                    left: 20 - 4,
                    child: Container(
                      width: _getBeforeWidth(_animation.value),
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: _getBeforeShadows(_animation.value),
                      ),
                    ),
                  ),
                  // After element
                  Positioned(
                    top: 20 - 4, // 50% - half height
                    left: 20 - 4, // 50% - half width
                    child: Container(
                      width: 8,
                      height: _getAfterHeight(_animation.value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: _getAfterShadows(_animation.value),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  double _getBeforeWidth(double progress) {
    if (progress <= 0.35) {
      return 8 + (32 * progress / 0.35);
    } else if (progress <= 0.7) {
      return 40 - (32 * (progress - 0.35) / 0.35);
    } else {
      return 8.0;
    }
  }

  double _getAfterHeight(double progress) {
    if (progress <= 0.35) {
      return 8 + (32 * progress / 0.35);
    } else if (progress <= 0.7) {
      // 35% to 70%: height goes from 40 to 8
      return 40 - (32 * (progress - 0.35) / 0.35);
    } else {
      return 8.0;
    }
  }

  List<BoxShadow> _getBeforeShadows(double progress) {
    const pink = Color.fromRGBO(225, 20, 98, 0.75);
    const lightBlue = Color.fromRGBO(111, 202, 220, 0.75);

    if (progress <= 0.35) {
      // 0% to 35%: shadows move from outer positions to center
      double pinkX = 16 - (16 * progress / 0.35);
      double blueX = -16 + (16 * progress / 0.35);
      return [
        BoxShadow(color: pink, offset: Offset(pinkX, -8), blurRadius: 0),
        BoxShadow(color: lightBlue, offset: Offset(blueX, 8), blurRadius: 0),
      ];
    } else if (progress <= 0.7) {
      // 35% to 70%: shadows move from center to opposite outer positions
      double pinkX = -16 * (progress - 0.35) / 0.35;
      double blueX = 16 * (progress - 0.35) / 0.35;
      return [
        BoxShadow(color: pink, offset: Offset(pinkX, -8), blurRadius: 0),
        BoxShadow(color: lightBlue, offset: Offset(blueX, 8), blurRadius: 0),
      ];
    } else {
      // 70% to 100%: shadows move back to original positions
      double pinkX = -16 + (32 * (progress - 0.7) / 0.3);
      double blueX = 16 - (32 * (progress - 0.7) / 0.3);
      return [
        BoxShadow(color: pink, offset: Offset(pinkX, -8), blurRadius: 0),
        BoxShadow(color: lightBlue, offset: Offset(blueX, 8), blurRadius: 0),
      ];
    }
  }

  List<BoxShadow> _getAfterShadows(double progress) {
    const green = Color.fromRGBO(61, 184, 143, 0.75);
    const orange = Color.fromRGBO(233, 169, 32, 0.75);

    if (progress <= 0.35) {
      // 0% to 35%: shadows move from outer positions to center
      double greenY = 16 - (16 * progress / 0.35);
      double orangeY = -16 + (16 * progress / 0.35);
      return [
        BoxShadow(color: green, offset: Offset(8, greenY), blurRadius: 0),
        BoxShadow(color: orange, offset: Offset(-8, orangeY), blurRadius: 0),
      ];
    } else if (progress <= 0.7) {
      // 35% to 70%: shadows move from center to opposite outer positions
      double greenY = -16 * (progress - 0.35) / 0.35;
      double orangeY = 16 * (progress - 0.35) / 0.35;
      return [
        BoxShadow(color: green, offset: Offset(8, greenY), blurRadius: 0),
        BoxShadow(color: orange, offset: Offset(-8, orangeY), blurRadius: 0),
      ];
    } else {
      // 70% to 100%: shadows move back to original positions
      double greenY = -16 + (32 * (progress - 0.7) / 0.3);
      double orangeY = 16 - (32 * (progress - 0.7) / 0.3);
      return [
        BoxShadow(color: green, offset: Offset(8, greenY), blurRadius: 0),
        BoxShadow(color: orange, offset: Offset(-8, orangeY), blurRadius: 0),
      ];
    }
  }
}
