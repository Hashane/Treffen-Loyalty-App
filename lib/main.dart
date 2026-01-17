import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'theme.dart';
import 'controllers/theme_controller.dart';
import 'core/config/env_config.dart';
import 'core/routes/app_router.dart';
import 'providers/home_provider.dart';
import 'widgets/animated_logo_loader.dart';
import 'widgets/global_error_overlay.dart';

const String _envFromDefine = String.fromEnvironment('ENV', defaultValue: 'dev');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeProvider())],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return GlobalErrorOverlay(
            child: GlobalLoaderOverlay(
              overlayWidgetBuilder: (_) => const _AppLoader(),
              child: MaterialApp.router(
                title: 'Loyalty App',
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: ThemeController.instance.themeMode,
                routerConfig: AppRouter.router,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppLoader extends StatelessWidget {
  const _AppLoader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.scrim.withValues(alpha: 0.35),
      child: const Center(child: AnimatedLogoLoader(size: 96)),
    );
  }
}
