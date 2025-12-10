import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShellScreen extends StatefulWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _getIndexFromRoute(String route) {
    if (route.contains('/home')) return 0;
    if (route.contains('/rewards')) return 1;
    if (route.contains('/settings')) return 2;
    return 0;
  }

  int get _currentIndex {
    final route = GoRouter.of(context).state.uri.toString();
    return _getIndexFromRoute(route);
  }

  void _onTabChange(int index) {
    final routes = ['/home', '/rewards', '/settings'];
    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 75.h,
        items: [
          CurvedNavigationBarItem(child: Icon(Icons.home_outlined), label: 'Home'),
          CurvedNavigationBarItem(child: Icon(Icons.card_giftcard), label: 'Rewards'),
          CurvedNavigationBarItem(child: Icon(Icons.history), label: 'Activity'),
          CurvedNavigationBarItem(child: Icon(Icons.perm_identity), label: 'Profile'),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 600),
        animationCurve: Curves.easeInOut,
        onTap: _onTabChange,
      ),
    );
  }
}
