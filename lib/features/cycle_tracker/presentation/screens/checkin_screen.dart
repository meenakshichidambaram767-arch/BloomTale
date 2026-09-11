import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/bloom_card.dart';
import '../../../../core/widgets/bloom_button.dart';
import '../../domain/entities/daily_check_in.dart';
import '../widgets/mood_selector_row.dart';

class CheckInScreen extends ConsumerStatefulWidget {
 const CheckInScreen({super.key});

 @override
 ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
 String? _selectedMood;
 final List<String> _selectedSymptoms = [];
 final TextEditingController _notesController = TextEditingController();
 bool _isSaving = false;

 static const List<Map<String, dynamic>> _symptoms = [
 {'label': 'Cramps', 'emoji': ''},
 {'label': 'Headache', 'emoji': ''},
 {'label': 'Bloating', 'emoji': ''},
 {'label': 'Tiredness', 'emoji': ''},
 {'label': 'Backache', 'emoji': ''},
 {'label': 'Acne', 'emoji': ''},
 {'label': 'Mood Changes', 'emoji': ''},
 {'label': 'Breast Tenderness', 'emoji': ''},
 ];

 @override
 void dispose() {
 _notesController.dispose();
 super.dispose();
 }

 Future<void> _saveCheckIn() async {
 if (_selectedMood == null) {
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: const Text('Please select your mood first '),
 behavior: SnackBarBehavior.floating,
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
 ),
 );
 return;
 }

 setState(() => _isSaving = true);

 final now = DateTime.now();
 final checkIn = DailyCheckIn(
 id: const Uuid().v4(),
 userId: 'default_user',
 date: now,
 mood: _selectedMood!,
 symptoms: List.from(_selectedSymptoms),
 notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
 createdAt: now,
 );

 await ref.read(cycleRepositoryProvider).saveDailyCheckIn(checkIn);
 ref.invalidate(recommendationsProvider);
 ref.invalidate(trackerInsightsProvider);

 if (mounted) {
 setState(() => _isSaving = false);
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: const Text('Check-in saved! You did great today '),
 behavior: SnackBarBehavior.floating,
 backgroundColor: BloomTheme.successGreen,
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
 ),
 );
 context.pop();
 }
 }

 @override
 Widget build(BuildContext context) {
 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 leading: IconButton(
 icon: const Icon(Icons.chevron_left_rounded, size: 28),
 onPressed: () => context.pop(),
 ),
 title: const Text('Daily Check-In'),
 ),
 body: SingleChildScrollView(
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // ─── Encouraging Banner ───
 BloomCard(
 backgroundColor: BloomTheme.secondaryPeach,
 padding: const EdgeInsets.all(20),
 child: Row(
 children: [
 Container(
 width: 50,
 height: 50,
 decoration: BoxDecoration(
 color: Colors.white.withOpacity(0.6),
 shape: BoxShape.circle,
 ),
 child: const Center(
 child: Text('', style: TextStyle(fontSize: 24)),
 ),
 ),
 const SizedBox(width: 14),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Text(
 'How was your day?',
 style: TextStyle(
 fontWeight: FontWeight.bold,
 fontSize: 16,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 4),
 Text(
 "There's no wrong answer — just check in with yourself.",
 style: TextStyle(
 fontSize: 12,
 color: BloomTheme.darkText.withOpacity(0.7),
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 const SizedBox(height: 28),

 // ─── Mood ───
 const Text(
 'How are you feeling?',
 style: TextStyle(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 14),
 MoodSelectorRow(
 selectedMood: _selectedMood,
 onMoodSelected: (m) => setState(() => _selectedMood = m),
 ),
 const SizedBox(height: 28),

 // ─── Symptoms ───
 const Text(
 'Any symptoms today?',
 style: TextStyle(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 4),
 const Text(
 'Select all that apply',
 style: TextStyle(fontSize: 12, color: BloomTheme.subText),
 ),
 const SizedBox(height: 14),
 Wrap(
 spacing: 8,
 runSpacing: 10,
 children: _symptoms.map((s) {
 final label = s['label'] as String;
 final emoji = s['emoji'] as String;
 final isSelected = _selectedSymptoms.contains(label);

 return GestureDetector(
 onTap: () {
 setState(() {
 if (isSelected) {
 _selectedSymptoms.remove(label);
 } else {
 _selectedSymptoms.add(label);
 }
 });
 },
 child: AnimatedContainer(
 duration: const Duration(milliseconds: 200),
 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
 decoration: BoxDecoration(
 color: isSelected
 ? BloomTheme.primaryRose
 : Colors.white,
 borderRadius: BorderRadius.circular(20),
 border: Border.all(
 color: isSelected ? BloomTheme.primaryRose : BloomTheme.borderSoft,
 width: isSelected ? 2 : 1,
 ),
 boxShadow: isSelected
 ? [
 BoxShadow(
 color: BloomTheme.primaryRose.withOpacity(0.2),
 blurRadius: 6,
 offset: const Offset(0, 2),
 ),
 ]
 : [],
 ),
 child: Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 Text(emoji, style: const TextStyle(fontSize: 14)),
 const SizedBox(width: 6),
 Text(
 label,
 style: TextStyle(
 fontSize: 13,
 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
 color: isSelected ? Colors.white : BloomTheme.darkText,
 ),
 ),
 ],
 ),
 ),
 );
 }).toList(),
 ),
 const SizedBox(height: 28),

 // ─── Notes ───
 const Text(
 'Quick notes (optional)',
 style: TextStyle(
 fontSize: 16,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 const SizedBox(height: 10),
 BloomCard(
 padding: const EdgeInsets.all(4),
 child: TextField(
 controller: _notesController,
 maxLines: 3,
 decoration: const InputDecoration(
 hintText: 'Anything on your mind today? ',
 hintStyle: TextStyle(color: BloomTheme.subText, fontSize: 14),
 border: InputBorder.none,
 contentPadding: EdgeInsets.all(12),
 ),
 ),
 ),
 const SizedBox(height: 32),

 // ─── Save Button ───
 BloomButton(
 text: 'Save Check-In ',
 onPressed: _saveCheckIn,
 isLoading: _isSaving,
 icon: Icons.check_rounded,
 ),
 const SizedBox(height: 30),
 ],
 ),
 ),
 );
 }
}
