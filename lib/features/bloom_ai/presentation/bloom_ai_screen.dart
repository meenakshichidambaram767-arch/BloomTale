import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/chat_bubble.dart';

class BloomAiScreen extends ConsumerStatefulWidget {
 const BloomAiScreen({super.key});

 @override
 ConsumerState<BloomAiScreen> createState() => _BloomAiScreenState();
}

class _BloomAiScreenState extends ConsumerState<BloomAiScreen> {
 final TextEditingController _inputController = TextEditingController();
 final ScrollController _scrollController = ScrollController();

 @override
 void dispose() {
 _inputController.dispose();
 _scrollController.dispose();
 super.dispose();
 }

 void _onSend() {
 final text = _inputController.text.trim();
 if (text.isEmpty) return;

 _inputController.clear();
 ref.read(bloomAiProvider.notifier).sendMessage(text);

 Future.delayed(const Duration(milliseconds: 200), () {
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
 final messagesAsync = ref.watch(bloomAiProvider);

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 AvatarWidget(expression: 'happy', size: 36),
 SizedBox(width: 8),
 Text('Ask Bloom '),
 ],
 ),
 ),
 body: Column(
 children: [
 // Safety Banner
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
 color: BloomTheme.warmSun,
 child: const Row(
 children: [
 Icon(Icons.shield_outlined, size: 18, color: BloomTheme.primaryRose),
 SizedBox(width: 8),
 Expanded(
 child: Text(
 'Bloom is your safe companion for non-judgmental facts. Not a medical doctor.',
 style: TextStyle(fontSize: 11, color: BloomTheme.darkText),
 ),
 ),
 ],
 ),
 ),
 Expanded(
 child: messagesAsync.when(
 data: (messages) => ListView.builder(
 controller: _scrollController,
 padding: const EdgeInsets.symmetric(vertical: 12),
 itemCount: messages.length,
 itemBuilder: (context, index) {
 final msg = messages[index];
 return ChatBubble(
 message: msg.text,
 isUser: msg.isUser,
 );
 },
 ),
 loading: () => const Center(child: CircularProgressIndicator()),
 error: (err, _) => Center(child: Text('Error: $err')),
 ),
 ),

 // Message Input Field
 Container(
 padding: const EdgeInsets.all(12),
 decoration: const BoxDecoration(
 color: Colors.white,
 border: Border(top: BorderSide(color: BloomTheme.borderSoft)),
 ),
 child: Row(
 children: [
 Expanded(
 child: TextField(
 controller: _inputController,
 onSubmitted: (_) => _onSend(),
 decoration: InputDecoration(
 hintText: 'Type your question for Bloom...',
 border: OutlineInputBorder(
 borderRadius: BorderRadius.circular(24),
 borderSide: const BorderSide(color: BloomTheme.borderSoft),
 ),
 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
 ),
 ),
 ),
 const SizedBox(width: 8),
 IconButton.filled(
 style: IconButton.styleFrom(
 backgroundColor: BloomTheme.primaryRose,
 ),
 icon: const Icon(Icons.send_rounded, color: Colors.white),
 onPressed: _onSend,
 ),
 ],
 ),
 ),
 ],
 ),
 );
 }
}
