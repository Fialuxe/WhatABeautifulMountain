import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassDistancePlate extends StatelessWidget {
  final double distanceKm;

  const GlassDistancePlate({super.key, required this.distanceKm});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -30,
      child:
          ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          distanceKm.toStringAsFixed(1),
                          style: GoogleFonts.outfit(
                            fontSize: 72,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                            shadows: [
                              const Shadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "km",
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms)
              .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
    );
  }
}
