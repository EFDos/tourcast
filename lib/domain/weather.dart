class Weather {
  final String description;
  final double temperature;

  Weather({required this.description, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> data) {
    final mainStruct = data['main'];
    if (mainStruct is! Map<String, dynamic>) {
      throw const FormatException('Invalid Json: Expected "main" as object');
    }

    final conditionList = data['weather'];
    if (conditionList is! List<dynamic>) {
      throw const FormatException('Invalid Json: Expected "weather" as list');
    }
    if (conditionList.isEmpty) {
      throw const FormatException(
          'Invalid Json: Expected "weather" as non-empty list');
    }

    final description = conditionList[0]['description'];
    if (description is! String) {
      throw const FormatException(
          'Invalid Json: Expected "description" as string');
    }

    final temp = mainStruct['temp'];
    if (temp is! double) {
      throw const FormatException('Invalid Json: Expected "temp" as double');
    }

    return Weather(description: description, temperature: temp);
  }

  @override
  bool operator ==(Object other) {
    return other is Weather &&
        description == other.description &&
        temperature == other.temperature;
  }

  @override
  int get hashCode => Object.hash(description, temperature);
}
