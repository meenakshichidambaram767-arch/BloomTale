import 'package:flutter/material.dart';
import '../app/theme.dart';

enum BloomButtonStyle { primary, secondary, outline }

class BloomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BloomButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const BloomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = BloomButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (style) {
      case BloomButtonStyle.primary:
        bg = BloomTheme.primaryRose;
        fg = Colors.white;
        break;
      case BloomButtonStyle.secondary:
        bg = BloomTheme.accentLavender;
        fg = BloomTheme.darkText;
        break;
      case BloomButtonStyle.outline:
        bg = Colors.transparent;
        fg = BloomTheme.primaryRose;
        border = const BorderSide(color: BloomTheme.primaryRose, width: 2);
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: style == BloomButtonStyle.outline ? 0 : 3,
          shadowColor: bg.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
            side: border,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: fg, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
