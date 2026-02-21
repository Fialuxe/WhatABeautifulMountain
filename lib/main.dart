import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/screens/fuji_screen.dart';

void main() {
  runApp(const FujiDistanceApp());
}

class FujiDistanceApp extends StatelessWidget {
  const FujiDistanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mt. Fuji Distance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA3C4DC)),
        useMaterial3: true,
      ),
      home: const FujiScreen(),
    );
  }
}
