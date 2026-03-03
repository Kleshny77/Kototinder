class Env {
  static const String catApiKey = String.fromEnvironment(
    'CAT_API_KEY',
    defaultValue: '',
  );
}
