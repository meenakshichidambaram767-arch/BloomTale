import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BloomAvatar extends StatelessWidget {
  final String avatarId;
  final String activity; // 'reading', 'music', 'active', 'cozy'
  final double size;
  final bool showBadge;

  const BloomAvatar({
    super.key,
    required this.avatarId,
    this.activity = 'reading',
    this.size = 80,
    this.showBadge = false,
  });

  String _getImageAssetPath() {
    final cleanAvatarId = avatarId.toLowerCase();
    if (['ananya', 'meera', 'lavanya', 'kiara'].contains(cleanAvatarId)) {
      return 'assets/images/avatar/${cleanAvatarId}_portrait.png';
    }
    switch (activity.toLowerCase()) {
      case 'reading':
        return 'assets/images/fluff_reading.png';
      case 'music':
        return 'assets/images/fluff_music.png';
      case 'active':
        return 'assets/images/fluff_active.png';
      case 'cozy':
      default:
        return 'assets/images/fluff_cozy.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _getImageAssetPath();

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BloomTheme.secondaryPeach.withValues(alpha: 0.3),
            border: Border.all(color: BloomTheme.primaryRose, width: 2),
            boxShadow: [
              BoxShadow(
                color: BloomTheme.primaryRose.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: BloomTheme.accentLavender,
                  child: Icon(
                    Icons.face_rounded,
                    size: size * 0.6,
                    color: BloomTheme.primaryRose,
                  ),
                );
              },
            ),
          ),
        ),
        if (showBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: BloomTheme.mintFresh,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: BloomTheme.darkText,
              ),
            ),
          ),
      ],
    );
  }
}

class BloomIllustrationCard extends StatelessWidget {
  final String avatarId;
  final String activity;
  final String title;
  final String subtitle;
  final String? badgeText;
  final double height;
  final Widget? customRightWidget;

  const BloomIllustrationCard({
    super.key,
    required this.avatarId,
    required this.activity,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.height = 180,
    this.customRightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BloomTheme.secondaryPeach, BloomTheme.accentLavender],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: BloomTheme.primaryRose.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (badgeText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: BloomTheme.primaryRose,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: BloomTheme.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BloomTheme.subText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          customRightWidget ??
              BloomAvatar(
                avatarId: avatarId,
                activity: activity,
                size: 90,
                showBadge: true,
              ),
        ],
      ),
    );
  }
}
