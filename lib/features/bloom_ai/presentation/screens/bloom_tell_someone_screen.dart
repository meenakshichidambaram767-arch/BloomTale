import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/providers.dart';

class BloomTellSomeoneScreen extends ConsumerStatefulWidget {
 const BloomTellSomeoneScreen({super.key});

 @override
 ConsumerState<BloomTellSomeoneScreen> createState() => _BloomTellSomeoneScreenState();
}

class _BloomTellSomeoneScreenState extends ConsumerState<BloomTellSomeoneScreen> {
 String _selectedRecipient = 'Parent / Guardian';
 String _selectedTopic = 'Something about my period';
 String _currentScript = '';
 bool _isLoadingScript = false;

 final List<String> _recipients = [
 'Parent / Guardian',
 'Teacher',
 'Healthcare professional',
 'Trusted adult',
 'Friend',
 ];

 final List<String> _topics = [
 'Something about my period',
 'Something I\'m worried about',
 'How I\'ve been feeling',
 'Something about my body',
 ];

 @override
 void initState() {
 super.initState();
 _generateScript('standard');
 }

 Future<void> _generateScript(String style) async {
 setState(() => _isLoadingScript = true);
 final repo = ref.read(bloomAiRepositoryProvider);
 final script = await repo.generateTellSomeoneStarter(_selectedRecipient, _selectedTopic, style: style);
 if (mounted) {
 setState(() {
 _currentScript = script;
 _isLoadingScript = false;
 });
 }
 }

 void _copyToClipboard() {
 Clipboard.setData(ClipboardData(text: _currentScript));
 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('Copied starter script to clipboard! ')),
 );
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Text('How Do I Tell Someone? '),
 centerTitle: true,
 ),
 body: ListView(
 padding: const EdgeInsets.all(16),
 children: [
 const Text(
 'Sharing your thoughts with a trusted adult helps you feel supported and safe. Choose who you want to talk to:',
 style: TextStyle(fontSize: 14, color: BloomTheme.subText),
 ),
 const SizedBox(height: 16),

 // Step 1: Who to talk to
 const Text('1. Who would you like to talk to?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
 const SizedBox(height: 8),
 Wrap(
 spacing: 8,
 children: _recipients.map((r) {
 final isSelected = r == _selectedRecipient;
 return ChoiceChip(
 label: Text(r),
 selected: isSelected,
 selectedColor: BloomTheme.primaryRose,
 labelStyle: TextStyle(
 color: isSelected ? Colors.white : BloomTheme.darkText,
 fontWeight: FontWeight.bold,
 fontSize: 13,
 ),
 onSelected: (_) {
 setState(() => _selectedRecipient = r);
 _generateScript('standard');
 },
 );
 }).toList(),
 ),
 const SizedBox(height: 20),

 // Step 2: Topic of concern
 const Text('2. What would you like help saying?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
 const SizedBox(height: 8),
 Wrap(
 spacing: 8,
 children: _topics.map((t) {
 final isSelected = t == _selectedTopic;
 return ChoiceChip(
 label: Text(t),
 selected: isSelected,
 selectedColor: BloomTheme.secondaryPeach,
 labelStyle: TextStyle(
 color: isSelected ? BloomTheme.darkText : BloomTheme.subText,
 fontWeight: FontWeight.bold,
 fontSize: 13,
 ),
 onSelected: (_) {
 setState(() => _selectedTopic = t);
 _generateScript('standard');
 },
 );
 }).toList(),
 ),
 const SizedBox(height: 24),

 // Generated Starter Script Box
 Container(
 padding: const EdgeInsets.all(20),
 decoration: BoxDecoration(
 color: Colors.white,
 borderRadius: BorderRadius.circular(20),
 border: Border.all(color: BloomTheme.secondaryPeach, width: 1.5),
 boxShadow: [
 BoxShadow(
 color: BloomTheme.primaryRose.withValues(alpha: 0.1),
 blurRadius: 10,
 offset: const Offset(0, 4),
 ),
 ],
 ),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Row(
 children: [
 Text(' You could start with:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BloomTheme.primaryRose)),
 ],
 ),
 const SizedBox(height: 12),
 if (_isLoadingScript)
 const Center(child: CircularProgressIndicator(color: BloomTheme.primaryRose))
 else
 Text(
 _currentScript,
 style: const TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w600, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 16),
 Wrap(
 spacing: 8,
 runSpacing: 8,
 children: [
 OutlinedButton(
 onPressed: () => _generateScript('shorter'),
 child: const Text('Make it shorter', style: TextStyle(fontSize: 12)),
 ),
 OutlinedButton(
 onPressed: () => _generateScript('casual'),
 child: const Text('Make it casual', style: TextStyle(fontSize: 12)),
 ),
 ElevatedButton.icon(
 onPressed: _copyToClipboard,
 icon: const Icon(Icons.copy_rounded, size: 16),
 label: const Text('Copy script', style: TextStyle(fontSize: 12)),
 ),
 ],
 )
 ],
 ),
 ),
 ],
 ),
 );
 }
}
