import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/providers.dart';
import '../app/theme.dart';
import '../models/bloom_ai.dart';

class BloomMessageBubble extends ConsumerStatefulWidget {
  final BloomAiMessage message;
  final Function(BloomAiMessage)? onSaveToggle;
  final Function(ExplanationLevel)? onLevelChanged;
  final Function(String)? onFollowUpSelected;

  const BloomMessageBubble({
    super.key,
    required this.message,
    this.onSaveToggle,
    this.onLevelChanged,
    this.onFollowUpSelected,
  });

  @override
  ConsumerState<BloomMessageBubble> createState() => _BloomMessageBubbleState();
}

class _BloomMessageBubbleState extends ConsumerState<BloomMessageBubble> {
  bool _isPlayingAudio = false;

  void _toggleAudio() {
    setState(() {
      _isPlayingAudio = !_isPlayingAudio;
    });

    if (_isPlayingAudio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reading Bloom\'s answer aloud...'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final isCrisis = widget.message.safetyCategory == SafetyCategory.crisis;
    final avatarAsync = ref.watch(selectedAvatarProvider);
    final companion = avatarAsync.asData?.value;
    final avatarId = companion?.id.toLowerCase() ?? 'ananya';
    final companionName = companion?.name ?? 'Bloom';

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 64, right: 16, top: 6, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: BloomTheme.primaryRose,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: BloomTheme.primaryRose.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.message.text,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 48, top: 8, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCrisis ? Colors.pink.shade50 : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: isCrisis ? BloomTheme.primaryRose : BloomTheme.borderSoft,
            width: isCrisis ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/avatar/${avatarId}_portrait.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 28,
                        height: 28,
                        color: BloomTheme.sandBeige,
                        child: const Icon(Icons.person, size: 16, color: BloomTheme.primaryRose),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  companionName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BloomTheme.darkText),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isPlayingAudio ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                    size: 18,
                    color: _isPlayingAudio ? BloomTheme.primaryRose : BloomTheme.subText,
                  ),
                  onPressed: _toggleAudio,
                  tooltip: 'Read Aloud',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
                IconButton(
                  icon: Icon(
                    widget.message.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    size: 18,
                    color: widget.message.isSaved ? BloomTheme.primaryRose : BloomTheme.subText,
                  ),
                  onPressed: () {
                    widget.onSaveToggle?.call(widget.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.message.isSaved ? 'Removed from saved insights' : 'Saved to your insights!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Save to Insights',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.message.activeText,
              style: const TextStyle(fontSize: 15, height: 1.4, color: BloomTheme.darkText),
            ),
            const SizedBox(height: 12),
            if (widget.message.detailedText != null) ...[
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: BloomTheme.softCream,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => widget.onLevelChanged?.call(ExplanationLevel.simple),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.message.explanationLevel == ExplanationLevel.simple
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: widget.message.explanationLevel == ExplanationLevel.simple
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : [],
                        ),
                        child: Text(
                          'Simple',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.message.explanationLevel == ExplanationLevel.simple
                                ? BloomTheme.primaryRose
                                : BloomTheme.subText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => widget.onLevelChanged?.call(ExplanationLevel.detail),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.message.explanationLevel == ExplanationLevel.detail
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: widget.message.explanationLevel == ExplanationLevel.detail
                              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                              : [],
                        ),
                        child: Text(
                          'More detail',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.message.explanationLevel == ExplanationLevel.detail
                                ? BloomTheme.primaryRose
                                : BloomTheme.subText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (widget.message.relatedStoryId != null) ...[
              InkWell(
                onTap: () => context.push('/stories/${widget.message.relatedStoryId}'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: BloomTheme.warmSun,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: BloomTheme.secondaryPeach),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.auto_stories_rounded, size: 18, color: BloomTheme.primaryRose),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Want to explore this lesson in Stories?',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 18, color: BloomTheme.primaryRose),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (widget.message.suggestedFollowUps.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.message.suggestedFollowUps.map((chip) {
                  return ActionChip(
                    label: Text(chip),
                    labelStyle: const TextStyle(fontSize: 12, color: BloomTheme.primaryRose, fontWeight: FontWeight.w600),
                    backgroundColor: BloomTheme.softCream,
                    side: const BorderSide(color: BloomTheme.borderSoft),
                    onPressed: () => widget.onFollowUpSelected?.call(chip),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
