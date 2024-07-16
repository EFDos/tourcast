import 'package:flutter/material.dart';
import 'package:tourcast/domain/city.dart';

class Constants {
  /// Current list of touring cities
  /// TODO: Make it dynamic
  static const cities = <City>[
    City(
      name: 'Silverstone',
      countryName: 'Great Britain',
      countryCode: 826,
    ),
    City(
      name: 'Sao Paulo',
      countryName: 'Brazil',
      countryCode: 76,
    ),
    City(
      name: 'Melbourne',
      countryName: 'Australia',
      countryCode: 36,
    ),
    City(
      name: 'Monte Carlo',
      countryName: 'Monaco',
      countryCode: 492,
    ),
  ];

  /// Used for background color gradient
  static const nightColorDark = Color(0xAA131862);

  /// Used for background color gradient
  static const nightColorLight = Color(0xAA546BAB);

  /// Background color gradient
  static const backgroundGradient = <Color>[nightColorLight, nightColorDark];
}
