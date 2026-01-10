import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends StatefulWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  int _getIndexFromRoute(String route) {
    if (route.contains('/home')) return 0;
    if (route.contains('/rewards')) return 1;
    if (route.contains('/activity')) return 2;
    if (route.contains('/profile')) return 3;
    return 0;
  }

  void _onTabChange(int index) {
    final routes = ['/home', '/rewards', '/activity', '/profile'];
    if (index < routes.length) {
      context.go(routes[index]);
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    _currentIndex = _getIndexFromRoute(GoRouter.of(context).state.uri.toString());

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Icon(Icons.home, color: colorScheme.onPrimary),
          Icon(Icons.card_giftcard, color: colorScheme.onPrimary),
          Icon(Icons.timeline, color: colorScheme.onPrimary),
          Icon(Icons.person, color: colorScheme.onPrimary),
        ],
        inactiveIcons: [
          Icon(Icons.home_outlined, color: colorScheme.onSurface.withValues(alpha: 0.6)),
          Icon(Icons.card_giftcard_outlined, color: colorScheme.onSurface.withValues(alpha: 0.6)),
          Icon(Icons.timeline_outlined, color: colorScheme.onSurface.withValues(alpha: 0.6)),
          Icon(Icons.person_outline, color: colorScheme.onSurface.withValues(alpha: 0.6)),
        ],
        color: colorScheme.surface,
        circleColor: colorScheme.surface,
        height: 60,
        circleWidth: 60,

        activeIndex: _currentIndex,
        onTap: _onTabChange,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        circleShadowColor: colorScheme.shadow.withOpacity(0.1),
        elevation: 10,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        circleGradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
      ),
    );
  }
}
