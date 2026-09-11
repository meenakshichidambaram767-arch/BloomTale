import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/bloom_button.dart';
import '../../../core/widgets/bloom_card.dart';
import '../domain/story.dart';

class StorySceneScreen extends ConsumerStatefulWidget {
 final String storyId;
 const StorySceneScreen({super.key, required this.storyId});

 @override
 ConsumerState<StorySceneScreen> createState() => _StorySceneScreenState();
}

class _StorySceneScreenState extends ConsumerState<StorySceneScreen> {
 String? _currentSceneId;
 String? _selectedNote;

 @override
 Widget build(BuildContext context) {
 final storyRepo = ref.watch(storyRepositoryProvider);

 return FutureBuilder<Story?>(
 future: storyRepo.getStoryById(widget.storyId),
 builder: (context, snapshot) {
 if (snapshot.connectionState == ConnectionState.waiting) {
 return const Scaffold(
 body: Center(child: CircularProgressIndicator()),
 );
 }

 final story = snapshot.data;
 if (story == null || story.scenes.isEmpty) {
 return Scaffold(
 appBar: AppBar(title: const Text('Story')),
 body: const Center(child: Text('Story content not found.')),
 );
 }

 _currentSceneId ??= story.scenes.first.id;

 if (_currentSceneId == 'completion') {
 WidgetsBinding.instance.addPostFrameCallback((_) {
 ref.read(userProvider.notifier).addXp(story.xpReward);
 context.go('/stories/${story.id}/completion');
 });
 return const Scaffold(body: Center(child: CircularProgressIndicator()));
 }

 final currentScene = story.scenes.firstWhere(
 (s) => s.id == _currentSceneId,
 orElse: () => story.scenes.first,
 );

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: Text(story.title),
 leading: IconButton(
 icon: const Icon(Icons.close_rounded),
 onPressed: () => context.pop(),
 ),
 ),
 body: SafeArea(
 child: Padding(
 padding: const EdgeInsets.all(20.0),
 child: Column(
 children: [
 // Scene Header & Companion Avatar
 Expanded(
 flex: 4,
 child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 AvatarWidget(
 avatarId: currentScene.characterId.isNotEmpty ? currentScene.characterId : story.starringCharacterId,
 expression: currentScene.characterExpression,
 size: 130,
 ),

 const SizedBox(height: 20),
 BloomCard(
 padding: const EdgeInsets.all(20),
 child: Text(
 currentScene.dialogue,
 textAlign: TextAlign.center,
 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
 fontSize: 17,
 height: 1.45,
 fontWeight: FontWeight.w600,
 ),
 ),
 ),
 ],
 ),
 ),

 // Educational Note Banner if a choice was clicked
 if (_selectedNote != null) ...[
 Container(
 padding: const EdgeInsets.all(12),
 margin: const EdgeInsets.only(bottom: 12),
 decoration: BoxDecoration(
 color: BloomTheme.mintFresh.withValues(alpha: 0.4),
 borderRadius: BorderRadius.circular(16),
 border: Border.all(color: BloomTheme.successGreen),
 ),
 child: Row(
 children: [
 const Icon(Icons.lightbulb_rounded, color: BloomTheme.successGreen),
 const SizedBox(width: 10),
 Expanded(
 child: Text(
 _selectedNote!,
 style: const TextStyle(
 fontSize: 13,
 color: BloomTheme.darkText,
 fontWeight: FontWeight.w600,
 ),
 ),
 ),
 ],
 ),
 ),
 ],

 // Dynamic Choices Options
 Expanded(
 flex: 3,
 child: ListView.separated(
 itemCount: currentScene.choices.length,
 separatorBuilder: (context, index) => const SizedBox(height: 10),
 itemBuilder: (context, index) {
 final choice = currentScene.choices[index];
 return BloomButton(
 text: choice.text,
 style: BloomButtonStyle.outline,
 onPressed: () {
 setState(() {
 _selectedNote = choice.educationalNote;
 _currentSceneId = choice.nextSceneId;
 });
 },
 );
 },
 ),
 ),
 ],
 ),
 ),
 ),
 );
 },
 );
 }
}
