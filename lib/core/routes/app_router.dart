import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loyalty/screens/home_screen.dart';
import 'package:loyalty/screens/login_screen.dart';
import 'package:loyalty/screens/settings_screen.dart';
import 'package:loyalty/screens/shell_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => LoginScreen(onLogin: () => context.go('/home')),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/rewards',
            name: 'rewards',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Rewards Screen'))),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
