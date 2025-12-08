import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  static Future<void> load({String env = 'dev'}) async {
    await dotenv.load(fileName: '.env.$env');
  }
}
