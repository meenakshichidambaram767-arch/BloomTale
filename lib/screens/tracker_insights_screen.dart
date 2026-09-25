import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(trackerInsightsProvider);
    final predictionAsync = ref.watch(cyclePredictionProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.auto_graph_rounded, size: 18, color: BloomTheme.darkText),
            SizedBox(width: 8),
            Text('My Insights'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Cycle Summary Card ───
            predictionAsync.when(
              data: (pred) => BloomCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cycle Overview',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: BloomTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _statBubble(
                          '${pred.averageCycleLength}',
                          'days',
                          'Avg Cycle',
                          BloomTheme.primaryRose,
                        ),
                        const SizedBox(width: 16),
                        _statBubble(
                          '${pred.averagePeriodLength}',
                          'days',
                          'Avg Period',
                          BloomTheme.warningOrange,
                        ),
                        const SizedBox(width: 16),
                        _statBubble(
                          'Day ${pred.currentCycleDay}',
                          '',
                          'Current',
                          BloomTheme.mintFresh,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Mini bar chart placeholder
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: BloomTheme.softCream,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(6, (i) {
                          final heights = [0.4, 0.7, 0.6, 0.85, 0.5, 0.65];
                          final labels = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 24,
                                  height: 50 * heights[i],
                                  decoration: BoxDecoration(
                                    color: i == 3
                                        ? BloomTheme.primaryRose
                                        : BloomTheme.primaryRose.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  labels[i],
                                  style: const TextStyle(fontSize: 9, color: BloomTheme.subText),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: BloomTheme.primaryRose),
                ),
              ),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),

            // ─── Patterns ───
            const Text(
              'Noticed Patterns',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: BloomTheme.darkText,
              ),
            ),
            const SizedBox(height: 12),
            insightsAsync.when(
              data: (insights) {
                if (insights.isEmpty) {
                  return BloomCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 8),
                        const Text(
                          'Keep logging check-ins to unlock helpful patterns!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: BloomTheme.subText, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: insights.map((ins) {
                    IconData icon;
                    Color iconColor;
                    switch (ins.type) {
                      case 'pattern':
                        icon = Icons.insights_rounded;
                        iconColor = BloomTheme.accentLavender;
                        break;
                      case 'summary':
                        icon = Icons.summarize_rounded;
                        iconColor = BloomTheme.mintFresh;
                        break;
                      default:
                        icon = Icons.lightbulb_outline_rounded;
                        iconColor = BloomTheme.warmSun;
                    }

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
                                color: iconColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: BloomTheme.darkText, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ins.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: BloomTheme.darkText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ins.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: BloomTheme.subText,
                                      height: 1.4,
                                    ),
                                  ),
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
            const SizedBox(height: 20),

            // ─── Disclaimer ───
            BloomCard(
              backgroundColor: BloomTheme.secondaryPeach,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Insights show patterns, not medical causes. Every girl's body has its own natural rhythm!",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: BloomTheme.darkText.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statBubble(String value, String unit, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: color == BloomTheme.mintFresh ? BloomTheme.darkText : color,
                    ),
                  ),
                  if (unit.isNotEmpty)
                    TextSpan(
                      text: ' $unit',
                      style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: BloomTheme.subText),
            ),
          ],
        ),
      ),
    );
  }
}
