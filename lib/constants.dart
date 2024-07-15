import 'package:flutter/material.dart';
import 'package:tourcast/domain/city.dart';

class Constants {
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

  static const nightColorDark = Color(0xAA131862);
  static const nightColorLight = Color(0xAA546BAB);
  static const backgroundGradient = <Color>[nightColorLight, nightColorDark];
}
