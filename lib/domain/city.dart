/// [City] Model class
class City {
  /// [City]'s name'
  final String name;

  /// Name of the country where [City] resides
  final String countryName;

  /// Code of the country where [City] resides
  final int countryCode;

  const City(
      {required this.name,
      required this.countryName,
      required this.countryCode});
}
