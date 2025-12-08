// lib/core/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loyalty/screens/home_screen.dart';
import 'package:loyalty/screens/login_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => LoginScreen(onLogin: () => context.go('/home')),
      ),
      GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
      // GoRoute(
      //   path: '/rewards',
      //   name: 'rewards',
      //   builder: (context, state) => const RewardsScreen(),
      // ),
      // GoRoute(
      //   path: '/profile/:userId',
      //   name: 'profile',
      //   builder: (context, state) {
      //     final userId = state.pathParameters['userId']!;
      //     return ProfileScreen(userId: userId);
      //   },
      // ),
      // GoRoute(
      //   path: '/rewards/:rewardId',
      //   name: 'rewardDetail',
      //   builder: (context, state) {
      //     final rewardId = state.pathParameters['rewardId']!;
      //     return RewardDetailScreen(rewardId: rewardId);
      //   },
      // ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
