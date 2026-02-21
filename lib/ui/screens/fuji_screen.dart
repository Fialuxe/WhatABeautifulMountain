import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/fuji_location.dart';
import '../../services/location_service.dart';
import '../../utils/color_utils.dart';
import '../widgets/floating_particles.dart';
import '../widgets/glass_distance_plate.dart';
import '../widgets/pulsing_aura.dart';

class FujiScreen extends StatefulWidget {
  const FujiScreen({super.key});

  @override
  State<FujiScreen> createState() => _FujiScreenState();
}

class _FujiScreenState extends State<FujiScreen> with TickerProviderStateMixin {
  final LocationService _locationService = LocationService();

  FujiLocation? _fujiLocation;
  String _statusMessage = 'Detecting Aura...';
  bool _isLoading = true;
  bool _showLocation = false;

  late final AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _initApp();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  Future<void> _initApp() async {
    bool hasPermission = await _locationService.checkPermissions();
    if (!hasPermission) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Location permissions denied.';
          _isLoading = false;
        });
      }
      return;
    }

    try {
      // Fetch initial immediately
      Position initialPos = await _locationService.getCurrentPosition();
      await _updateLocation(initialPos);

      // Listen to continuous streams
      _locationService.getPositionStream().listen((Position position) {
        _updateLocation(position);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Failed to acquire location.';
          if (_fujiLocation != null) {
            _isLoading = false; // keep old data if available
          }
        });
      }
    }
  }

  Future<void> _updateLocation(Position position) async {
    final locationData = await _locationService.getFujiLocation(position);
    if (!mounted || locationData == null) return;

    setState(() {
      _fujiLocation = locationData;
      _isLoading = false;

      // Adjust aura breathing rhythm based on proximity
      if (locationData.distanceKm < 50) {
        _breathingController.duration = const Duration(seconds: 2);
        if (!_breathingController.isAnimating) {
          _breathingController.repeat(reverse: true);
        }
      } else {
        _breathingController.duration = const Duration(seconds: 4);
        if (!_breathingController.isAnimating) {
          _breathingController.repeat(reverse: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = ColorUtils.getSkyPaletteByTimeOfDay(DateTime.now());

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackgroundGradient(palette),
          const FloatingParticles(),
          if (_isLoading) _buildLoadingState() else _buildMainUI(),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient(List<Color> palette) {
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 20),
        Text(
          _statusMessage,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fade(duration: 1.seconds).shimmer(),
      ],
    );
  }

  Widget _buildMainUI() {
    final isClose = _fujiLocation != null && _fujiLocation!.distanceKm < 50;
    final auraColor = isClose
        ? Colors.pinkAccent.withValues(alpha: 0.3)
        : Colors.white.withValues(alpha: 0.2);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTitleAndLocationToggle(),
        const SizedBox(height: 30),
        _buildFujiDisplay(auraColor),
      ],
    );
  }

  Widget _buildTitleAndLocationToggle() {
    String locationText =
        "Lat: ${_fujiLocation!.currentLat.toStringAsFixed(4)}, Lng: ${_fujiLocation!.currentLng.toStringAsFixed(4)}";
    if (_fujiLocation!.city != null && _fujiLocation!.prefecture != null) {
      locationText += "\n${_fujiLocation!.city}, ${_fujiLocation!.prefecture}";
    } else if (_fujiLocation!.city != null) {
      locationText += "\n${_fujiLocation!.city}";
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showLocation = !_showLocation;
            });
          },
          child: Text(
            "Mt. Fuji",
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 4,
              shadows: [const Shadow(color: Colors.black26, blurRadius: 10)],
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0),
        ),

        // AnimatedSize ensures multiline text renders completely and gracefully
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: _showLocation ? null : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Text(
                  locationText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFujiDisplay(Color auraColor) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        PulsingAura(controller: _breathingController, auraColor: auraColor),

        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                spreadRadius: 5,
                offset: Offset(0, 10),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

        GlassDistancePlate(distanceKm: _fujiLocation!.distanceKm),
      ],
    );
  }
}
