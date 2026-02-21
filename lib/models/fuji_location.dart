class FujiLocation {
  final double distanceKm;
  final double currentLat;
  final double currentLng;
  final String? city;
  final String? prefecture;

  FujiLocation({
    required this.distanceKm,
    required this.currentLat,
    required this.currentLng,
    this.city,
    this.prefecture,
  });
}
