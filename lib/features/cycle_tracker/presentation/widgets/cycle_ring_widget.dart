import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../domain/entities/cycle.dart';

class CycleRingWidget extends StatelessWidget {
 final int currentDay;
 final int totalDays;
 final CyclePhase currentPhase;
 final int periodLength;
 final String nextPeriodText;
 final VoidCallback? onTap;

 const CycleRingWidget({
 super.key,
 required this.currentDay,
 required this.totalDays,
 required this.currentPhase,
 this.periodLength = 5,
 required this.nextPeriodText,
 this.onTap,
 });

 @override
 Widget build(BuildContext context) {
 return Row(
 children: [
 // Cycle Ring
 SizedBox(
 width: 100,
 height: 100,
 child: CustomPaint(
 painter: _CycleRingPainter(
 currentDay: currentDay,
 totalDays: totalDays,
 periodLength: periodLength,
 ),
 child: Center(
 child: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 const Text(
 'Day',
 style: TextStyle(
 fontSize: 11,
 color: BloomTheme.subText,
 ),
 ),
 Text(
 '$currentDay',
 style: const TextStyle(
 fontSize: 26,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 Text(
 'of $totalDays',
 style: const TextStyle(
 fontSize: 11,
 color: BloomTheme.subText,
 ),
 ),
 ],
 ),
 ),
 ),
 ),
 const SizedBox(width: 16),
 // Phase Info
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 currentPhase.displayName,
 style: const TextStyle(
 fontWeight: FontWeight.bold,
 fontSize: 16,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 4),
 Text(
 _phaseShortDescription(currentPhase),
 style: const TextStyle(
 fontSize: 12,
 color: BloomTheme.subText,
 height: 1.3,
 ),
 ),
 const SizedBox(height: 8),
 GestureDetector(
 onTap: onTap,
 child: Container(
 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
 decoration: BoxDecoration(
 color: BloomTheme.warmSun,
 borderRadius: BorderRadius.circular(16),
 ),
 child: Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 const Text(' ', style: TextStyle(fontSize: 12)),
 Text(
 nextPeriodText,
 style: const TextStyle(
 fontSize: 12,
 fontWeight: FontWeight.w600,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(width: 4),
 const Icon(Icons.chevron_right, size: 14, color: BloomTheme.primaryRose),
 ],
 ),
 ),
 ),
 ],
 ),
 ),
 ],
 );
 }

 String _phaseShortDescription(CyclePhase phase) {
 switch (phase) {
 case CyclePhase.menstrual:
 return 'Your body is resting and renewing.';
 case CyclePhase.follicular:
 return 'Your body is preparing for ovulation.';
 case CyclePhase.ovulation:
 return 'Mid-cycle phase — you may feel energized.';
 case CyclePhase.luteal:
 return 'Approaching your next cycle.';
 }
 }
}

class _CycleRingPainter extends CustomPainter {
 final int currentDay;
 final int totalDays;
 final int periodLength;

 _CycleRingPainter({
 required this.currentDay,
 required this.totalDays,
 required this.periodLength,
 });

 @override
 void paint(Canvas canvas, Size size) {
 final center = Offset(size.width / 2, size.height / 2);
 final radius = size.width / 2 - 6;
 const strokeWidth = 8.0;
 const startAngle = -math.pi / 2;
 final sweepPerDay = (2 * math.pi) / totalDays;

 // Background ring
 final bgPaint = Paint()
 ..color = Colors.grey.shade200
 ..style = PaintingStyle.stroke
 ..strokeWidth = strokeWidth
 ..strokeCap = StrokeCap.round;
 canvas.drawCircle(center, radius, bgPaint);

 // Period phase (rose)
 final periodPaint = Paint()
 ..color = BloomTheme.primaryRose
 ..style = PaintingStyle.stroke
 ..strokeWidth = strokeWidth
 ..strokeCap = StrokeCap.round;
 canvas.drawArc(
 Rect.fromCircle(center: center, radius: radius),
 startAngle,
 sweepPerDay * periodLength,
 false,
 periodPaint,
 );

 // Follicular phase (peach/gold)
 final follicularEnd = (totalDays / 2 - 1).round();
 final follicularPaint = Paint()
 ..color = const Color(0xFFFBD38D)
 ..style = PaintingStyle.stroke
 ..strokeWidth = strokeWidth
 ..strokeCap = StrokeCap.round;
 canvas.drawArc(
 Rect.fromCircle(center: center, radius: radius),
 startAngle + sweepPerDay * periodLength,
 sweepPerDay * (follicularEnd - periodLength),
 false,
 follicularPaint,
 );

 // Ovulation phase (mint)
 final ovulationLength = 4;
 final ovulationPaint = Paint()
 ..color = BloomTheme.mintFresh
 ..style = PaintingStyle.stroke
 ..strokeWidth = strokeWidth
 ..strokeCap = StrokeCap.round;
 canvas.drawArc(
 Rect.fromCircle(center: center, radius: radius),
 startAngle + sweepPerDay * follicularEnd,
 sweepPerDay * ovulationLength,
 false,
 ovulationPaint,
 );

 // Luteal phase (lavender)
 final lutealStart = follicularEnd + ovulationLength;
 final lutealPaint = Paint()
 ..color = BloomTheme.accentLavender
 ..style = PaintingStyle.stroke
 ..strokeWidth = strokeWidth
 ..strokeCap = StrokeCap.round;
 canvas.drawArc(
 Rect.fromCircle(center: center, radius: radius),
 startAngle + sweepPerDay * lutealStart,
 sweepPerDay * (totalDays - lutealStart),
 false,
 lutealPaint,
 );

 // Current day indicator dot
 final dotAngle = startAngle + sweepPerDay * (currentDay - 1);
 final dotCenter = Offset(
 center.dx + radius * math.cos(dotAngle),
 center.dy + radius * math.sin(dotAngle),
 );
 final dotPaint = Paint()
 ..color = BloomTheme.darkText
 ..style = PaintingStyle.fill;
 canvas.drawCircle(dotCenter, 5, dotPaint);

 final dotOuterPaint = Paint()
 ..color = Colors.white
 ..style = PaintingStyle.stroke
 ..strokeWidth = 2;
 canvas.drawCircle(dotCenter, 5, dotOuterPaint);
 }

 @override
 bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
