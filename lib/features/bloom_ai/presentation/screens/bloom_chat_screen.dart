import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../domain/entities/bloom_context.dart';
import '../providers/bloom_ai_providers.dart';
import '../widgets/bloom_message_bubble.dart';
import '../widgets/bloom_input_bar.dart';

class BloomChatScreen extends ConsumerStatefulWidget {
 final String? initialQuestion;
 final String? source;
 final String? topic;

 const BloomChatScreen({
 super.key,
 this.initialQuestion,
 this.source,
 this.topic,
 });

 @override
 ConsumerState<BloomChatScreen> createState() => _BloomChatScreenState();
}

class _BloomChatScreenState extends ConsumerState<BloomChatScreen> {
 final ScrollController _scrollController = ScrollController();

 @override
 void initState() {
 super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) {
 if (widget.source != null || widget.topic != null) {
 final ctx = BloomContext(
 source: widget.source,
 topic: widget.topic,
 initialQuestion: widget.initialQuestion,
 );
 ref.read(bloomChatProvider.notifier).setContext(ctx);
 }

 if (widget.initialQuestion != null && widget.initialQuestion!.isNotEmpty) {
 _sendQuestion(widget.initialQuestion!);
 }
 });
 }

 @override
 void dispose() {
 _scrollController.dispose();
 super.dispose();
 }

 void _sendQuestion(String text) {
 ref.read(bloomChatProvider.notifier).sendMessage(text);
 _scrollToBottom();
 }

 void _scrollToBottom() {
 Future.delayed(const Duration(milliseconds: 300), () {
 if (_scrollController.hasClients) {
 _scrollController.animateTo(
 _scrollController.position.maxScrollExtent,
 duration: const Duration(milliseconds: 300),
 curve: Curves.easeOut,
 );
 }
 });
 }

 @override
 Widget build(BuildContext context) {
 final chatState = ref.watch(bloomChatProvider);

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 const Text(' ', style: TextStyle(fontSize: 18)),
 Text(widget.topic ?? 'Ask Bloom'),
 ],
 ),
 actions: [
 IconButton(
 icon: const Icon(Icons.record_voice_over_rounded, color: BloomTheme.primaryRose),
 tooltip: 'Tell Someone',
 onPressed: () => context.push('/bloom/tell-someone'),
 ),
 ],
 ),
 body: Column(
 children: [
 // Safety Banner
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
 color: BloomTheme.warmSun,
 child: const Row(
 children: [
 Icon(Icons.shield_outlined, size: 16, color: BloomTheme.primaryRose),
 SizedBox(width: 8),
 Expanded(
 child: Text(
 'Bloom is your safe companion for non-judgmental facts. Not a medical doctor.',
 style: TextStyle(fontSize: 11, color: BloomTheme.darkText, fontWeight: FontWeight.w500),
 ),
 ),
 ],
 ),
 ),

 // Chat Messages View
 Expanded(
 child: ListView.builder(
 controller: _scrollController,
 padding: const EdgeInsets.all(12),
 itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
 itemBuilder: (context, index) {
 if (index < chatState.messages.length) {
 final msg = chatState.messages[index];
 return BloomMessageBubble(
 message: msg,
 onSaveToggle: (m) => ref.read(bloomChatProvider.notifier).toggleSaveAnswer(m),
 onLevelChanged: (level) => ref.read(bloomChatProvider.notifier).setExplanationLevel(level),
 onFollowUpSelected: (question) {
 if (question == "Open Period Prep Assistant") {
 context.push('/bloom/prepare');
 } else if (question == "Try Tell Someone Assistant" || question == "Help me tell someone") {
 context.push('/bloom/tell-someone');
 } else if (question == "Write in Journal") {
 context.push('/bloom/journal');
 } else if (question == "Learn more in Stories") {
 context.push('/bloom/learn');
 } else {
 _sendQuestion(question);
 }
 },
 );
 }

 // Loading / Typing Indicator
 return Padding(
 padding: const EdgeInsets.all(12),
 child: Row(
 children: [
 const Text(' ', style: TextStyle(fontSize: 16)),
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
 decoration: BoxDecoration(
 color: Colors.white,
 borderRadius: BorderRadius.circular(16),
 border: Border.all(color: BloomTheme.borderSoft),
 ),
 child: const Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 SizedBox(
 width: 14,
 height: 14,
 child: CircularProgressIndicator(strokeWidth: 2, color: BloomTheme.primaryRose),
 ),
 SizedBox(width: 8),
 Text('Bloom is thinking...', style: TextStyle(fontSize: 12, color: BloomTheme.subText)),
 ],
 ),
 ),
 ],
 ),
 );
 },
 ),
 ),

 // Bottom Input Bar
 BloomInputBar(
 onSend: (text) => _sendQuestion(text),
 hintText: widget.topic != null ? 'Ask about ${widget.topic}...' : 'Type your question...',
 ),
 ],
 ),
 );
 }
}
