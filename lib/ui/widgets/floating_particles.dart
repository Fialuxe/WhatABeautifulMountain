import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _Particle {
  double x, y, size, speed;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class _FloatingParticlesState extends State<FloatingParticles> {
  final List<_Particle> _particles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(
        _Particle(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          size: rng.nextDouble() * 8 + 4,
          speed: rng.nextDouble() * 0.005 + 0.002,
        ),
      );
    }
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      setState(() {
        for (var p in _particles) {
          p.y -= p.speed;
          if (p.y < -0.1) {
            p.y = 1.1;
            p.x = Random().nextDouble();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: _particles
          .map(
            (p) => Positioned(
              left: p.x * size.width,
              top: p.y * size.height,
              child: Container(
                width: p.size,
                height: p.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.8),
                      blurRadius: p.size * 2,
                      spreadRadius: p.size,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
