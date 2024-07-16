/// Provide [apiKey] through `env.json` and running `make run`or `make test`
/// or manually using --dart-define=API_KEY={YOUR_API}
class Environment {
  static const String apiKey = String.fromEnvironment('API_KEY');
}
