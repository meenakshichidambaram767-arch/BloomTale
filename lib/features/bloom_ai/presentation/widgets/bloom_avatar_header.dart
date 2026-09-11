import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/entities/bloom_enums.dart';

class BloomAvatarHeader extends ConsumerWidget {
  final BloomExpression expression;
  final double size;
  final String? title;
  final String subtitle;

  const BloomAvatarHeader({
    super.key,
    this.expression = BloomExpression.happy,
    this.size = 90,
    this.title,
    this.subtitle = "What would you like to talk about today?",
  });

  String _getExpressionLabel() {
    switch (expression) {
      case BloomExpression.happy:
        return "Always here for you";
      case BloomExpression.calm:
        return "Take your time";
      case BloomExpression.thinking:
        return "Thinking carefully...";
      case BloomExpression.curious:
        return "Learning together";
      case BloomExpression.concerned:
        return "Listening to you";
      case BloomExpression.reassuring:
        return "You're safe here";
      case BloomExpression.encouraging:
        return "You can do this!";
      case BloomExpression.celebrating:
        return "Great job!";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarAsync = ref.watch(selectedAvatarProvider);
    final companion = avatarAsync.asData?.value;
    final avatarId = companion?.id.toLowerCase() ?? 'ananya';
    final avatarName = companion?.name ?? 'Bloom';
    final effectiveTitle = title ?? "Hi, I'm $avatarName";

    return Column(
      children: [
        Container(
          width: size + 10,
          height: size + 10,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [BloomTheme.primaryRose, BloomTheme.sageGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: BloomTheme.primaryRose.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar/${avatarId}_portrait.png',
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: BloomTheme.sandBeige,
                    child: const Icon(Icons.person, color: BloomTheme.primaryRose),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          effectiveTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: BloomTheme.darkText,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: BloomTheme.warmSun,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            _getExpressionLabel(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BloomTheme.primaryRose,
            ),
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BloomTheme.subText,
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ]
      ],
    );
  }
}
