/// [GeoCoordinates] Model class
/// Holds [latitude] and [longitude] data in response
/// to some location
class GeoCoordinates {
  final double latitude;
  final double longitude;

  const GeoCoordinates({required this.latitude, required this.longitude});

  /// Factory [GeoCoordinates] from a Json object
  factory GeoCoordinates.fromJson(Map<String, dynamic> data) {
    final lat = data['lat'];
    final lon = data['lon'];
    if (lat is! double) {
      throw const FormatException('Invalid Json: Expected "lat" as double');
    }
    if (lon is! double) {
      throw const FormatException('Invalid Json: Expected "lon" as double');
    }

    return GeoCoordinates(latitude: lat, longitude: lon);
  }

  @override
  bool operator ==(Object other) {
    return other is GeoCoordinates &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
