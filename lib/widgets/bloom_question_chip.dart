import 'package:flutter/material.dart';
import '../app/theme.dart';

class BloomQuestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const BloomQuestionChip({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BloomTheme.secondaryPeach),
            boxShadow: [
              BoxShadow(
                color: BloomTheme.primaryRose.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.help_outline_rounded,
                size: 16,
                color: BloomTheme.primaryRose,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BloomTheme.darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
