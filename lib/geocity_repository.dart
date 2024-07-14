class Location {
  int latitude = 0;
  int longitude = 0;
}

class GeocityRepository {
  Future<Location> getCityLocation(String cityName) {
    return Future.delayed(Duration.zero, () => Location());
  }
}
