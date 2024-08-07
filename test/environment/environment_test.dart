import 'package:flutter_test/flutter_test.dart';
import 'package:tourcast/environment/environment.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('api key from environment', () async {
    String apiKey = Environment.apiKey;
    assert(apiKey.isNotEmpty);
  });
}
