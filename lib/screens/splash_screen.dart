import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/providers.dart';
import '../app/theme.dart';
import '../widgets/logo_widget.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNav();
  }

  Future<void> _checkNav() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final userState = ref.read(userProvider);
    userState.when(
      data: (user) {
        if (user != null) {
          context.go('/home');
        } else {
          context.go('/profile-setup');
        }
      },
      loading: () => context.go('/profile-setup'),
      error: (err, stack) => context.go('/profile-setup'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BloomLogo(
                size: 140,
                isHero: true,
                showText: false,
              ),
              const SizedBox(height: 32),
              Text(
                'BloomTale',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: BloomTheme.darkText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: BloomTheme.sageGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Every girl deserves to understand her story.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BloomTheme.darkText,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  color: BloomTheme.primaryRose,
                  strokeWidth: 3.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
