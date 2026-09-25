import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../widgets/logo_widget.dart';

class MainWrapperScreen extends StatelessWidget {
  final Widget child;
  const MainWrapperScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/stories')) return 1;
    if (location.startsWith('/bloom-ai')) return 2;
    if (location.startsWith('/tracker')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/stories');
        break;
      case 2:
        context.go('/bloom-ai');
        break;
      case 3:
        context.go('/tracker');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (idx) => _onItemTapped(idx, context),
          selectedItemColor: BloomTheme.primaryRose,
          unselectedItemColor: BloomTheme.subText,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_rounded),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: BloomLogo(size: 24, showText: false),
              activeIcon: BloomLogo(size: 26, showText: false, isHero: true),
              label: 'Bloom AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'Track',
            ),
          ],
        ),
      ),
    );
  }
}
