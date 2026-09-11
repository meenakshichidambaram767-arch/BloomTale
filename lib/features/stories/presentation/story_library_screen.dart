import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/bloom_card.dart';

import '../../avatar/presentation/widgets/bloom_avatar.dart';


class StoryLibraryScreen extends ConsumerWidget {
 const StoryLibraryScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final storiesAsync = ref.watch(storyListProvider);
 final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
 final avatar = selectedAvatarAsync.asData?.value;
 final avatarId = avatar?.id ?? 'default_avatar';
 final avatarName = avatar?.name ?? 'Bloom';

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Text('Story Library '),
 ),
 body: storiesAsync.when(
 data: (stories) => ListView(
 padding: const EdgeInsets.all(20),
 children: [
 // Reading Activity Banner
 BloomIllustrationCard(
 avatarId: avatarId,
 activity: 'reading',
 height: 190,
 badgeText: ' Story Library',
 title: 'Explore Stories with $avatarName',
 subtitle: 'Interactive story modules teaching health, confidence, and puberty.',
 ),
 const SizedBox(height: 20),
 const Text(
 'Available Story Modules',
 style: TextStyle(
 fontSize: 15,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 12),
 ...stories.map((story) {
 final isAvailable = story.scenes.isNotEmpty;
 final characterId = story.starringCharacterId;


 return Padding(
 padding: const EdgeInsets.only(bottom: 16),
 child: BloomCard(
 onTap: isAvailable
 ? () => context.push('/stories/${story.id}')
 : () {
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(
 content: Text('This story pack will unlock in the next update! '),
 ),
 );
 },
 child: Row(
 children: [
 BloomAvatar(
 avatarId: characterId,
 activity: 'reading',
 size: 64,
 showBadge: true,
 ),
 const SizedBox(width: 16),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
 decoration: BoxDecoration(
 color: BloomTheme.accentLavender.withValues(alpha: 0.4),
 borderRadius: BorderRadius.circular(10),
 ),
 child: Text(
 story.category,
 style: const TextStyle(
 fontSize: 11,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 ),
 const SizedBox(height: 6),
 Text(
 story.title,
 style: const TextStyle(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 ),
 ),
 const SizedBox(height: 4),
 Text(
 story.description,
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
 const SizedBox(width: 8),
 Icon(
 isAvailable ? Icons.arrow_forward_ios_rounded : Icons.lock_outline_rounded,
 size: 18,
 color: isAvailable ? BloomTheme.primaryRose : BloomTheme.subText,
 ),
 ],
 ),
 ),
 );
 }).toList(),
 ]),

 loading: () => const Center(child: CircularProgressIndicator()),
 error: (err, _) => Center(child: Text('Error loading stories: $err')),
 ),
 );
 }
}
