import 'package:flutter/material.dart';
import '../controllers/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = ThemeController.instance.themeMode;
  }

  Future<void> _setMode(ThemeMode mode) async {
    setState(() => _mode = mode);
    await ThemeController.instance.setThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Appearance')),
          ListTile(
            title: const Text('System Default'),
            trailing: Icon(
              _mode == ThemeMode.system ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _mode == ThemeMode.system ? Theme.of(context).colorScheme.primary : null,
            ),
            onTap: () => _setMode(ThemeMode.system),
          ),
          ListTile(
            title: const Text('Light'),
            trailing: Icon(
              _mode == ThemeMode.light ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _mode == ThemeMode.light ? Theme.of(context).colorScheme.primary : null,
            ),
            onTap: () => _setMode(ThemeMode.light),
          ),
          ListTile(
            title: const Text('Dark'),
            trailing: Icon(
              _mode == ThemeMode.dark ? Icons.radio_button_checked : Icons.radio_button_off,
              color: _mode == ThemeMode.dark ? Theme.of(context).colorScheme.primary : null,
            ),
            onTap: () => _setMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}
