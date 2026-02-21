import 'package:flutter/material.dart';

class PulsingAura extends StatelessWidget {
  final AnimationController controller;
  final Color auraColor;

  const PulsingAura({
    super.key,
    required this.controller,
    required this.auraColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 290 + (controller.value * 20),
          height: 290 + (controller.value * 20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: auraColor,
            boxShadow: [
              BoxShadow(
                color: auraColor,
                blurRadius: 40 + (controller.value * 20),
                spreadRadius: 10 + (controller.value * 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
