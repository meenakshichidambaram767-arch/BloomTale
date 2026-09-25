import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';
import '../widgets/bloom_avatar.dart';

class TrackerRecommendationsScreen extends ConsumerWidget {
  const TrackerRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(recommendationsProvider);
    final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
    final avatarId = selectedAvatarAsync.asData?.value.id ?? 'default_avatar';

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Text('Preparation & Prep'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            BloomIllustrationCard(
              avatarId: avatarId,
              activity: 'packing',
              height: 180,
              badgeText: ' Cycle Prep Kit',
              title: 'Bloom Prep & Self-Care Assistant',
              subtitle: 'Tailored recommendations based on your current cycle phase and schedule.',
            ),
            const SizedBox(height: 24),

            const Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),

            recommendationsAsync.when(
              data: (recs) {
                if (recs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text('No recommendations at this time. You are all set! '),
                    ),
                  );
                }
                return Column(
                  children: recs.map((rec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BloomCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: BloomTheme.warmSun,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text('', style: TextStyle(fontSize: 22)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rec.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: BloomTheme.darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    rec.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: BloomTheme.subText,
                                      height: 1.4,
                                    ),
                                  ),
                                  if (rec.route != null) ...[
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () => context.push(rec.route!),
                                      child: const Text(
                                        'Explore →',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: BloomTheme.primaryRose,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: BloomTheme.primaryRose),
              ),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
