import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final int conditionId;
  const WeatherIcon({required this.conditionId, super.key});

  dynamic fromConditionId() {
    if (conditionId >= 200 && conditionId < 233) {
      return Icons.thunderstorm;
    }
    if (conditionId >= 300 && conditionId < 333) {
      return Icons.storm;
    }
    if (conditionId >= 500 && conditionId < 533) {
      return Icons.storm;
    }
    if (conditionId >= 600 && conditionId < 633) {
      return Icons.snowing;
    }
    if (conditionId == 800) {
      return Icons.sunny;
    }
    if (conditionId > 800) {
      return Icons.wb_cloudy_sharp;
    }
    return Icons.signal_wifi_connected_no_internet_4;
  }

  Color colorFromConditionId() {
    if (conditionId >= 200 && conditionId < 233) {
      return Colors.blue.shade700;
    }
    if (conditionId >= 300 && conditionId < 333) {
      return Colors.blue.shade100;
    }
    if (conditionId >= 500 && conditionId < 533) {
      return Colors.blue.shade600;
    }
    if (conditionId >= 600 && conditionId < 633) {
      return Colors.lightBlue;
    }
    if (conditionId == 800) {
      return Colors.yellow.shade900;
    }
    if (conditionId > 800) {
      return Colors.grey.shade500;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(fromConditionId(), color: colorFromConditionId());
  }
}
