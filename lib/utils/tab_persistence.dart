import 'package:shared_preferences/shared_preferences.dart';

class TabPersistence {
  static const _key = 'last_tab_index';

  static Future<int> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> save(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);
  }
}
