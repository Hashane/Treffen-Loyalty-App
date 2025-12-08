import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loyalty/screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme.dart';
import 'controllers/theme_controller.dart';
import 'core/config/env_config.dart';

const String _envFromDefine = String.fromEnvironment('ENV', defaultValue: 'dev');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment file based on --dart-define ENV value (default: dev)
  await EnvConfig.load(env: _envFromDefine);

  await ThemeController.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Loyalty App',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeController.instance.themeMode,
          home: LoginScreen(
            onLogin: () {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          ),
        );
      },
    );
  }
}
