import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BloomProgressBar extends StatelessWidget {
 final double progress; // 0.0 to 1.0
 final String? label;
 final double height;

 const BloomProgressBar({
 super.key,
 required this.progress,
 this.label,
 this.height = 16.0,
 });

 @override
 Widget build(BuildContext context) {
 final clamped = progress.clamp(0.0, 1.0);
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 if (label != null) ...[
 Text(
 label!,
 style: const TextStyle(
 fontSize: 12,
 fontWeight: FontWeight.bold,
 color: BloomTheme.subText,
 ),
 ),
 const SizedBox(height: 6),
 ],
 Container(
 height: height,
 width: double.infinity,
 decoration: BoxDecoration(
 color: BloomTheme.borderSoft,
 borderRadius: BorderRadius.circular(height / 2),
 ),
 child: FractionallySizedBox(
 alignment: Alignment.centerLeft,
 widthFactor: clamped == 0 ? 0.02 : clamped,
 child: Container(
 decoration: BoxDecoration(
 gradient: const LinearGradient(
 colors: [BloomTheme.primaryRose, BloomTheme.accentLavender],
 ),
 borderRadius: BorderRadius.circular(height / 2),
 ),
 ),
 ),
 ),
 ],
 );
 }
}
