import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../avatar/domain/avatar.dart';
import 'widgets/bloom_avatar.dart';
import '../../../core/widgets/bloom_button.dart';
import '../../../core/widgets/bloom_card.dart';

class MeetAvatarScreen extends ConsumerStatefulWidget {
 const MeetAvatarScreen({super.key});

 @override
 ConsumerState<MeetAvatarScreen> createState() => _MeetAvatarScreenState();
}

class _MeetAvatarScreenState extends ConsumerState<MeetAvatarScreen> {
 String? _selectedId;

 @override
 Widget build(BuildContext context) {
 final avatarsAsync = ref.watch(availableAvatarsProvider);
 final userAsync = ref.watch(userProvider);
 final userName = userAsync.asData?.value?.name ?? 'there';
 final currentAvatarId = userAsync.asData?.value?.avatarId ?? 'default_avatar';

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 body: SafeArea(
 child: avatarsAsync.when(
 data: (avatars) {
 _selectedId ??= currentAvatarId;
 final selectedAvatar = avatars.firstWhere(
 (a) => a.id == _selectedId,
 orElse: () => avatars.first,
 );

 return Padding(
 padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
 child: Column(
 children: [
 // Title Header
 Text(
 'Meet your Bloom Friends ',
 style: Theme.of(context).textTheme.displayLarge?.copyWith(
 color: BloomTheme.primaryRose,
 fontSize: 24,
 ),
 textAlign: TextAlign.center,
 ),
 const SizedBox(height: 6),
 Text(
 'Who would you like to bloom with, $userName?',
 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
 color: BloomTheme.subText,
 ),
 textAlign: TextAlign.center,
 ),
 const SizedBox(height: 16),

 // Avatar Selection Chips / List
 SizedBox(
 height: 90,
 child: ListView.separated(
 scrollDirection: Axis.horizontal,
 itemCount: avatars.length,
 separatorBuilder: (context, index) => const SizedBox(width: 12),
 itemBuilder: (context, index) {
 final avatar = avatars[index];
 final isSelected = avatar.id == selectedAvatar.id;
 return GestureDetector(
 onTap: () => setState(() => _selectedId = avatar.id),
 child: Column(
 children: [
 Container(
 decoration: BoxDecoration(
 shape: BoxShape.circle,
 border: Border.all(
 color: isSelected ? BloomTheme.primaryRose : Colors.transparent,
 width: 3,
 ),
 ),
 child: BloomAvatar(
 avatarId: avatar.id,
 expression: 'happy',
 size: 58,
 animate: isSelected,
 ),
 ),
 const SizedBox(height: 4),
 Text(
 avatar.name,
 style: TextStyle(
 fontSize: 12,
 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
 color: isSelected ? BloomTheme.primaryRose : BloomTheme.darkText,
 ),
 ),
 ],
 ),
 );
 },
 ),
 ),

 const SizedBox(height: 12),

 // Selected Avatar Detail Card
 Expanded(
 child: SingleChildScrollView(
 child: BloomCard(
 padding: const EdgeInsets.all(20),
 child: Column(
 children: [
 BloomAvatar(
 avatarId: selectedAvatar.id,
 expression: 'happy',
 sizeCategory: AvatarSize.large,
 showBadge: true,
 ),
 const SizedBox(height: 16),
 Row(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 Text(
 selectedAvatar.name,
 style: Theme.of(context).textTheme.titleLarge?.copyWith(
 color: BloomTheme.primaryRose,
 fontWeight: FontWeight.bold,
 ),
 ),
 if (selectedAvatar.age > 0 && selectedAvatar.id != 'default_avatar')
 Padding(
 padding: const EdgeInsets.only(left: 8.0),
 child: Chip(
 label: Text(
 'Age ${selectedAvatar.age}',
 style: const TextStyle(fontSize: 11, color: BloomTheme.darkText),
 ),
 backgroundColor: BloomTheme.warmSun,
 visualDensity: VisualDensity.compact,
 padding: EdgeInsets.zero,
 ),
 ),
 ],
 ),
 if (selectedAvatar.quote.isNotEmpty) ...[
 const SizedBox(height: 8),
 Text(
 '"${selectedAvatar.quote}"',
 textAlign: TextAlign.center,
 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
 fontStyle: FontStyle.italic,
 color: BloomTheme.darkText,
 ),
 ),
 ],
 const SizedBox(height: 12),
 Text(
 selectedAvatar.description,
 textAlign: TextAlign.center,
 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
 color: BloomTheme.subText,
 height: 1.4,
 ),
 ),
 if (selectedAvatar.personalityTraits.isNotEmpty) ...[
 const SizedBox(height: 14),
 Wrap(
 spacing: 6,
 runSpacing: 6,
 alignment: WrapAlignment.center,
 children: selectedAvatar.personalityTraits
 .map(
 (trait) => Container(
 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
 decoration: BoxDecoration(
 color: BloomTheme.secondaryPeach.withValues(alpha: 0.5),
 borderRadius: BorderRadius.circular(12),
 ),
 child: Text(
 ' $trait',
 style: const TextStyle(
 fontSize: 11,
 fontWeight: FontWeight.w600,
 color: BloomTheme.darkText,
 ),
 ),
 ),
 )
 .toList(),
 ),
 ],
 const SizedBox(height: 20),
 Text(
 '${selectedAvatar.name}\'s Activities & Scenes ',
 style: const TextStyle(
 fontSize: 14,
 fontWeight: FontWeight.bold,
 color: BloomTheme.primaryRose,
 ),
 ),
 const SizedBox(height: 10),
 SizedBox(
 height: 140,
 child: ListView(
 scrollDirection: Axis.horizontal,
 children: [
 SizedBox(
 width: 140,
 child: BloomIllustrationCard(
 avatarId: selectedAvatar.id,
 activity: 'reading',
 height: 140,
 title: 'Reading',
 ),
 ),
 const SizedBox(width: 10),
 SizedBox(
 width: 140,
 child: BloomIllustrationCard(
 avatarId: selectedAvatar.id,
 activity: 'journaling',
 height: 140,
 title: 'Journaling',
 ),
 ),
 const SizedBox(width: 10),
 SizedBox(
 width: 140,
 child: BloomIllustrationCard(
 avatarId: selectedAvatar.id,
 activity: 'tea',
 height: 140,
 title: 'Tea & Warmth',
 ),
 ),
 const SizedBox(width: 10),
 SizedBox(
 width: 140,
 child: BloomIllustrationCard(
 avatarId: selectedAvatar.id,
 activity: 'sports',
 height: 140,
 title: 'Sports & Active',
 ),
 ),
 const SizedBox(width: 10),
 SizedBox(
 width: 140,
 child: BloomIllustrationCard(
 avatarId: selectedAvatar.id,
 activity: 'music',
 height: 140,
 title: 'Music & Relax',
 ),
 ),
 const SizedBox(width: 10),
 SizedBox(
 width: 140,
 child: BloomIllustrationCard(
 avatarId: selectedAvatar.id,
 activity: 'packing',
 height: 140,
 title: 'Prep Kit',
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 ),
 ),

 const SizedBox(height: 16),

 // Actions
 BloomButton(
 text: 'Choose ${selectedAvatar.name} as Companion ',
 onPressed: () async {
 await ref.read(userProvider.notifier).selectAvatar(selectedAvatar.id);
 if (context.mounted) {
 context.go('/home');
 }
 },
 ),
 const SizedBox(height: 8),
 TextButton(
 onPressed: () => context.go('/home'),
 child: const Text(
 'Skip for now (Use default companion)',
 style: TextStyle(color: BloomTheme.subText, fontSize: 13),
 ),
 ),
 ],
 ),
 );
 },
 loading: () => const Center(child: CircularProgressIndicator()),
 error: (err, _) => Center(child: Text('Error loading avatars: $err')),
 ),
 ),
 );
 }
}

