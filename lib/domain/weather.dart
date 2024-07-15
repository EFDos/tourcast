class Weather {
  static const Weather undefined = Weather(description: '', temperature: 0.0);
  final String description;
  final double temperature;
  final double min;
  final double max;
  final int conditionId;

  const Weather(
      {required this.description,
      required this.temperature,
      this.min = 0.0,
      this.max = 0.0,
      this.conditionId = 0});

  Weather copyWith(
      {String? description,
      double? temperature,
      double? min,
      double? max,
      int? conditionId}) {
    return Weather(
        description: description ?? this.description,
        temperature: temperature ?? this.temperature,
        min: min ?? this.min,
        max: max ?? this.max,
        conditionId: conditionId ?? this.conditionId);
  }

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

    var id = conditionList[0]['id'];
    if (id is! int) {
      id = 0;
    }

    final temp = mainStruct['temp'];
    if (temp is! double) {
      throw const FormatException('Invalid Json: Expected "temp" as double');
    }

    var min = mainStruct['temp_min'];
    if (min is! double) {
      min = 0.0;
    }

    var max = mainStruct['temp_max'];
    if (max is! double) {
      max = 0.0;
    }

    return Weather(
        description: description,
        temperature: temp,
        min: min,
        max: max,
        conditionId: id);
  }

  @override
  bool operator ==(Object other) {
    return other is Weather &&
        description == other.description &&
        temperature == other.temperature &&
        min == other.min &&
        max == other.max;
  }

  @override
  int get hashCode => Object.hash(description, temperature, min, max);
}
