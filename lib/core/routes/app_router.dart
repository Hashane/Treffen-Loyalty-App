import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loyalty/screens/activity_screen.dart';
import 'package:loyalty/screens/category_detail_screen.dart';
import 'package:loyalty/screens/home_screen.dart';
import 'package:loyalty/screens/login_screen.dart';
import 'package:loyalty/screens/offer_detail_screen.dart';
import 'package:loyalty/screens/profile_screen.dart';
import 'package:loyalty/screens/rewards_screen.dart';
import 'package:loyalty/screens/settings_screen.dart';
import 'package:loyalty/screens/shell_screen.dart';
import 'package:loyalty/screens/voucher_details_page.dart';

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
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Change the opacity of the screen using a Curve based on the the animation's
                  // value
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),

          GoRoute(
            path: '/rewards',
            name: 'rewards',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: RewardsScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
            routes: [
              GoRoute(
                path: 'category/:categoryName',
                name: 'category-detail',
                pageBuilder: (context, state) {
                  final categoryName = state.pathParameters['categoryName']!;
                  final rewards = state.extra as List<Map<String, dynamic>>;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: CategoryDetailScreen(categoryName: categoryName, rewards: rewards),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
                        child: child,
                      );
                    },
                  );
                },
              ),
              GoRoute(
                path: 'offer',
                name: 'offer-detail',
                pageBuilder: (context, state) {
                  final offer = state.extra as Map<String, dynamic>;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: OfferDetailScreen(offer: offer),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
                        child: child,
                      );
                    },
                  );
                },
              ),
              GoRoute(
                path: 'voucher-details',
                name: 'voucher-details',
                pageBuilder: (context, state) {
                  final data = state.extra as Map<String, dynamic>;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: VoucherDetailsPage(
                      voucherId: data['voucherId'] as int,
                      voucherCode: data['voucherCode'] as String,
                      offerTitle: data['offerTitle'] as String,
                      storeName: data['storeName'] as String,
                      validUntil: data['validUntil'] as String?,
                      imageUrl: data['imageUrl'] as String?,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/activity',
            name: 'activity',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const ActivityScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
            routes: [
              GoRoute(
                path: 'settings',
                name: 'settings',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic)),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
