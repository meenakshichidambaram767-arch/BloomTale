import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../providers/bloom_ai_providers.dart';
import '../widgets/bloom_topic_card.dart';

class BloomTopicsScreen extends ConsumerWidget {
 const BloomTopicsScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final topicsAsync = ref.watch(bloomTopicsProvider);

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Text('Explore Topics '),
 centerTitle: true,
 ),
 body: topicsAsync.when(
 data: (topics) => ListView(
 padding: const EdgeInsets.all(16),
 children: [
 const Text(
 'Choose a topic to explore safe questions, facts, and advice:',
 style: TextStyle(fontSize: 14, color: BloomTheme.subText),
 ),
 const SizedBox(height: 16),
 GridView.builder(
 shrinkWrap: true,
 physics: const NeverScrollableScrollPhysics(),
 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: 2,
 crossAxisSpacing: 12,
 mainAxisSpacing: 12,
 childAspectRatio: 0.95,
 ),
 itemCount: topics.length,
 itemBuilder: (context, index) {
 final topic = topics[index];
 return BloomTopicCard(
 topic: topic,
 onTap: () {
 context.push('/bloom/chat?topic=${Uri.encodeComponent(topic.title)}');
 },
 );
 },
 ),
 ],
 ),
 loading: () => const Center(child: CircularProgressIndicator(color: BloomTheme.primaryRose)),
 error: (err, stack) => Center(child: Text('Error loading topics: $err')),
 ),
 );
 }
}
