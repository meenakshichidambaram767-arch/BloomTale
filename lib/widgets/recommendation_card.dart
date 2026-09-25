import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../models/cycle.dart';
import 'bloom_card.dart';

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;

  const RecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBg;
    Color buttonColor;
    IconData iconData;

    switch (recommendation.category) {
      case RecommendationCategory.periodPreparation:
      case RecommendationCategory.calendarPlanning:
        cardBg = BloomTheme.secondaryPeach;
        buttonColor = BloomTheme.primaryRose;
        iconData = Icons.backpack_outlined;
        break;
      case RecommendationCategory.education:
        cardBg = BloomTheme.mintFresh;
        buttonColor = BloomTheme.successGreen;
        iconData = Icons.auto_stories_rounded;
        break;
      case RecommendationCategory.bloomAi:
        cardBg = BloomTheme.accentLavender;
        buttonColor = BloomTheme.darkText;
        iconData = Icons.chat_bubble_outline_rounded;
        break;
      case RecommendationCategory.wellness:
      case RecommendationCategory.reminder:
      default:
        cardBg = BloomTheme.warmSun;
        buttonColor = BloomTheme.warningOrange;
        iconData = Icons.spa_outlined;
        break;
    }

    return BloomCard(
      backgroundColor: cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: buttonColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  recommendation.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: BloomTheme.darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            recommendation.description,
            style: const TextStyle(
              fontSize: 13,
              color: BloomTheme.darkText,
              height: 1.4,
            ),
          ),
          if (recommendation.actionButtonText != null && recommendation.route != null) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onPressed: () {
                  if (recommendation.route != null) {
                    context.push(recommendation.route!);
                  }
                },
                child: Text(
                  recommendation.actionButtonText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
