import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/bloom_button.dart';
import '../../../core/widgets/bloom_card.dart';

class StoryCompletionScreen extends ConsumerWidget {
 final String storyId;
 const StoryCompletionScreen({super.key, required this.storyId});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 body: SafeArea(
 child: Padding(
 padding: const EdgeInsets.all(24.0),
 child: Column(
 children: [
 const Spacer(),
 const AvatarWidget(expression: 'confident', size: 140, showBadge: true),
 const SizedBox(height: 28),
 Text(
 'Story Completed! ',
 style: Theme.of(context).textTheme.displayLarge?.copyWith(
 color: BloomTheme.primaryRose,
 ),
 textAlign: TextAlign.center,
 ),
 const SizedBox(height: 12),
 BloomCard(
 padding: const EdgeInsets.all(20),
 child: Column(
 children: [
 const Text(
 'You earned +20 XP!',
 style: TextStyle(
 fontSize: 20,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 8),
 Text(
 'You\'ve taken another amazing step in understanding your body, building confidence, and growing every day.',
 textAlign: TextAlign.center,
 style: Theme.of(context).textTheme.bodyMedium,
 ),
 ],
 ),
 ),
 const Spacer(),
 BloomButton(
 text: 'Return to Home Dashboard',
 onPressed: () => context.go('/home'),
 ),
 const SizedBox(height: 12),
 BloomButton(
 text: 'Explore More Stories',
 style: BloomButtonStyle.outline,
 onPressed: () => context.go('/stories'),
 ),
 const SizedBox(height: 16),
 ],
 ),
 ),
 ),
 );
 }
}
