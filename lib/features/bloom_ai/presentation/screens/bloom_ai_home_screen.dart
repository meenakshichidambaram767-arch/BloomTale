import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/providers.dart';
import '../providers/bloom_ai_providers.dart';
import '../widgets/bloom_avatar_header.dart';
import '../widgets/bloom_question_chip.dart';

class BloomAiHomeScreen extends ConsumerWidget {
  const BloomAiHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarExpression = ref.watch(bloomAvatarExpressionProvider);
    final avatarAsync = ref.watch(selectedAvatarProvider);
    final companionName = avatarAsync.asData?.value?.name ?? 'Bloom';

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Bloom AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded, color: BloomTheme.primaryRose),
            tooltip: 'Saved Answers',
            onPressed: () => _showSavedAnswersModal(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Active Companion Watercolor Header
            BloomAvatarHeader(
              expression: avatarExpression,
              size: 95,
              title: "Hi, I'm $companionName",
              subtitle: "Your safe, private companion to ask, learn, prepare, and reflect.",
            ),
            const SizedBox(height: 24),

            // 2. Floating Quick Prompt Carousel
            const Text(
              'Floating Quick Prompts',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BloomQuestionChip(
                    text: 'Is my period cycle normal?',
                    onTap: () => context.push('/bloom/chat?initialQuestion=Is my period cycle normal?'),
                  ),
                  const SizedBox(width: 8),
                  BloomQuestionChip(
                    text: 'How can I ease cramps naturally?',
                    onTap: () => context.push('/bloom/chat?initialQuestion=How can I ease cramps naturally?'),
                  ),
                  const SizedBox(width: 8),
                  BloomQuestionChip(
                    text: 'What should I pack for school?',
                    onTap: () => context.push('/bloom/chat?initialQuestion=What should I pack for school?'),
                  ),
                  const SizedBox(width: 8),
                  BloomQuestionChip(
                    text: 'How to handle mood swings?',
                    onTap: () => context.push('/bloom/chat?initialQuestion=How to handle mood swings?'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. 4 Main Action Hub Tiles Grid (Floating Cards)
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.35,
              children: [
                _buildHubTile(
                  context,
                  title: 'Ask Bloom',
                  subtitle: 'Chat anytime privately',
                  color: BloomTheme.warmSun.withValues(alpha: 0.6),
                  borderColor: BloomTheme.secondaryPeach,
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => context.push('/bloom/chat'),
                ),
                _buildHubTile(
                  context,
                  title: 'Learn',
                  subtitle: 'Explore visual lessons',
                  color: BloomTheme.sageGreen.withValues(alpha: 0.15),
                  borderColor: BloomTheme.sageGreen,
                  icon: Icons.auto_stories_rounded,
                  onTap: () => context.push('/bloom/learn'),
                ),
                _buildHubTile(
                  context,
                  title: 'Prepare',
                  subtitle: 'Get ready for events',
                  color: BloomTheme.sandBeige.withValues(alpha: 0.35),
                  borderColor: BloomTheme.sandBeige,
                  icon: Icons.check_circle_outline_rounded,
                  onTap: () => context.push('/bloom/prepare'),
                ),
                _buildHubTile(
                  context,
                  title: 'Reflect',
                  subtitle: 'Private journal check-in',
                  color: BloomTheme.primaryRose.withValues(alpha: 0.12),
                  borderColor: BloomTheme.primaryRose,
                  icon: Icons.favorite_outline_rounded,
                  onTap: () => context.push('/bloom/journal'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Topic Library Banner
            InkWell(
              onTap: () => context.push('/bloom/topics'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BloomTheme.borderSoft, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: BloomTheme.primaryRose.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.category_rounded, color: BloomTheme.primaryRose, size: 24),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Explore Topics Library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: BloomTheme.darkText)),
                          SizedBox(height: 2),
                          Text('Puberty, Periods, Emotions, Hygiene & Confidence', style: TextStyle(fontSize: 12, color: BloomTheme.subText)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: BloomTheme.primaryRose),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. Contextual Recommendation Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    BloomTheme.warmSun,
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BloomTheme.secondaryPeach, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bloom Noticed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BloomTheme.primaryRose)),
                  const SizedBox(height: 8),
                  const Text(
                    'Sports Day is coming up soon and your period window might overlap. Want to keep your essentials ready?',
                    style: TextStyle(fontSize: 13, color: BloomTheme.darkText, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/bloom/prepare'),
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Prepare with Bloom', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHubTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required Color borderColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: BloomTheme.darkText, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BloomTheme.darkText),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: BloomTheme.subText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSavedAnswersModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final savedList = ref.watch(savedAnswersProvider);
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(Icons.bookmark_rounded, color: BloomTheme.primaryRose),
                  SizedBox(width: 8),
                  Text('Saved Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              if (savedList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Bookmark useful Bloom responses during chat to remember them here!', style: TextStyle(color: BloomTheme.subText)),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: savedList.length,
                    itemBuilder: (context, index) {
                      final item = savedList[index];
                      return ListTile(
                        leading: const Icon(Icons.bookmark_border_rounded, color: BloomTheme.primaryRose),
                        title: Text(item.text, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey),
                          onPressed: () {
                            ref.read(savedAnswersProvider.notifier).removeAnswer(item);
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
