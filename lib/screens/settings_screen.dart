import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.asData?.value;

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Settings & Privacy ️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          BloomCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: BloomTheme.primaryRose),
                  title: const Text('Name / Nickname'),
                  subtitle: Text(user?.name ?? 'Maya'),
                ),
                const Divider(),
                Consumer(
                  builder: (context, ref, child) {
                    final avatarAsync = ref.watch(selectedAvatarProvider);
                    final avatarName = avatarAsync.asData?.value.name ?? 'Bloomie';
                    return ListTile(
                      leading: const Icon(Icons.face_rounded, color: BloomTheme.primaryRose),
                      title: const Text('Bloom Companion'),
                      subtitle: Text('Current Friend: $avatarName (Tap to change)'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => context.push('/meet-avatar'),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          BloomCard(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: BloomTheme.primaryRose),
                  title: Text('Privacy Policy & Child Safety'),
                  subtitle: Text('Minimal data collection policy active.'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded, color: BloomTheme.primaryRose),
                  title: const Text('About BloomTale'),
                  subtitle: const Text('Version 1.0.0 (MVP Foundation)'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
              context.go('/welcome');
            },
            child: const Text('Reset Demo Data / Sign Out'),
          ),
        ],
      ),
    );
  }
}
