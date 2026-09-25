import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../models/bloom_ai.dart';

class BloomTopicCard extends StatelessWidget {
  final BloomTopic topic;
  final VoidCallback onTap;

  const BloomTopicCard({
    super.key,
    required this.topic,
    required this.onTap,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'spa':
        return Icons.spa_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'clean_hands':
        return Icons.clean_hands_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'help_outline':
        return Icons.help_outline_rounded;
      default:
        return Icons.lightbulb_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(topic.colorHex);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconData(topic.iconName), color: BloomTheme.primaryRose, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                topic.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: BloomTheme.darkText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                topic.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: BloomTheme.subText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${topic.suggestedQuestions.length} questions',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: BloomTheme.primaryRose,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: BloomTheme.primaryRose),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
