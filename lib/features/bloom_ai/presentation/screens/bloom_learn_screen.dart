import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';

class BloomLearnScreen extends ConsumerWidget {
 const BloomLearnScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Text('Learn with Bloom '),
 centerTitle: true,
 ),
 body: ListView(
 padding: const EdgeInsets.all(16),
 children: [
 // Featured Contextual Lesson Banner
 Container(
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
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
 decoration: BoxDecoration(
 color: Colors.white.withValues(alpha: 0.9),
 borderRadius: BorderRadius.circular(12),
 ),
 child: const Text(
 ' Recommended for you',
 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BloomTheme.primaryRose),
 ),
 ),
 const SizedBox(height: 12),
 const Text(
 'Understanding Period Cramps & Body Shifts',
 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 6),
 const Text(
 'A short visual story helping you understand uterine muscles, relief tips, and self-care.',
 style: TextStyle(fontSize: 13, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 16),
 Row(
 children: [
 const Icon(Icons.timer_outlined, size: 16, color: BloomTheme.darkText),
 const SizedBox(width: 4),
 const Text('3 min read', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
 const SizedBox(width: 16),
 const Icon(Icons.stars_rounded, size: 16, color: Colors.amber),
 const SizedBox(width: 4),
 const Text('+50 XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
 const Spacer(),
 ElevatedButton(
 onPressed: () => context.push('/stories/first_period'),
 style: ElevatedButton.styleFrom(
 backgroundColor: BloomTheme.primaryRose,
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
 ),
 child: const Text('Start Lesson →', style: TextStyle(fontSize: 14)),
 ),
 ],
 )
 ],
 ),
 ),
 const SizedBox(height: 24),

 const Text(
 'Explore Educational Stories',
 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 12),

 _buildLessonCard(
 context,
 title: 'My First Period',
 description: 'Follow Maya as she experiences her first period and discovers she is not alone.',
 duration: '5 min',
 xp: '+100 XP',
 storyId: 'first_period',
 ),
 const SizedBox(height: 12),
 _buildLessonCard(
 context,
 title: 'Hormones & Mood Waves',
 description: 'Why do emotions feel so intense during puberty? Learn gentle grounding exercises.',
 duration: '4 min',
 xp: '+75 XP',
 storyId: 'first_period',
 ),
 const SizedBox(height: 12),
 _buildLessonCard(
 context,
 title: 'Building Body Confidence',
 description: 'Celebrate your unique growth journey without comparing yourself to others.',
 duration: '3 min',
 xp: '+50 XP',
 storyId: 'first_period',
 ),
 ],
 ),
 );
 }

 Widget _buildLessonCard(
 BuildContext context, {
 required String title,
 required String description,
 required String duration,
 required String xp,
 required String storyId,
 }) {
 return Card(
 elevation: 2,
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
 child: Padding(
 padding: const EdgeInsets.all(16),
 child: Row(
 children: [
 Container(
 padding: const EdgeInsets.all(12),
 decoration: const BoxDecoration(
 color: BloomTheme.softCream,
 shape: BoxShape.circle,
 ),
 child: const Icon(Icons.auto_stories_rounded, color: BloomTheme.primaryRose, size: 28),
 ),
 const SizedBox(width: 14),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: BloomTheme.darkText)),
 const SizedBox(height: 4),
 Text(description, style: const TextStyle(fontSize: 12, color: BloomTheme.subText), maxLines: 2, overflow: TextOverflow.ellipsis),
 const SizedBox(height: 8),
 Row(
 children: [
 Text(duration, style: const TextStyle(fontSize: 11, color: BloomTheme.subText)),
 const SizedBox(width: 12),
 Text(xp, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: BloomTheme.primaryRose)),
 ],
 )
 ],
 ),
 ),
 IconButton(
 icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: BloomTheme.primaryRose),
 onPressed: () => context.push('/stories/$storyId'),
 ),
 ],
 ),
 ),
 );
 }
}
