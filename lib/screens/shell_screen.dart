import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../utils/tab_persistence.dart';

class ShellScreen extends StatefulWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;
  bool _initialized = false;

  static const _routes = ['/home', '/rewards', '/activity', '/profile'];

  int _indexFromRoute(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/rewards')) return 1;
    if (location.startsWith('/activity')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  void initState() {
    super.initState();

    // Restore last selected tab on app start
    TabPersistence.load().then((index) {
      if (!mounted) return;
      setState(() {
        _currentIndex = index;
        _initialized = true;
      });
    });
  }

  void _onTabChange(int index) {
    if (index == _currentIndex) return;

    // Safety: never leave loader stuck during fast tab switching
    context.loaderOverlay.hide();

    TabPersistence.save(index);
    context.go(_routes[index]);

    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = GoRouter.of(context).state.uri.toString();

    // Deep link always wins over persisted state
    final derivedIndex = _indexFromRoute(location);
    if (_initialized && derivedIndex != _currentIndex) {
      _currentIndex = derivedIndex;
      TabPersistence.save(derivedIndex);
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CircleNavBar(
        activeIndex: _currentIndex,
        onTap: _onTabChange,
        height: 60,
        circleWidth: 60,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        elevation: 10,
        color: colorScheme.surface,
        circleColor: colorScheme.surface,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        circleShadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
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
      ),
    );
  }
}
