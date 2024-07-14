class Weather {
  final String main;
  final double temperature;

  Weather({required this.main, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> data) {
    final mainStruct = data['main'];
    if (mainStruct is! Map<String, dynamic>) {
      throw const FormatException('Invalid Json: Expected main as object');
    }

    final temp = mainStruct['temp'];
    if (temp is! double) {
      throw const FormatException('Invalid Json: Expected temp as double');
    }

    return Weather(main: 'Blah', temperature: temp);
  }

  @override
  bool operator ==(Object other) {
    return other is Weather &&
        main == other.main &&
        temperature == other.temperature;
  }

  @override
  int get hashCode => Object.hash(main, temperature);


}
