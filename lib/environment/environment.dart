import 'package:flutter/services.dart' show rootBundle;

class Environment {
  static Future<String> getApiKey() async {
    return (await rootBundle.loadString('assets/api.env')).replaceAll('\n', '');
  }
}
