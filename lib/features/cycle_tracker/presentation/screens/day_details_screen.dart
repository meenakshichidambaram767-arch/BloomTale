import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/bloom_card.dart';
import '../../domain/entities/cycle.dart';
import '../widgets/mood_selector_row.dart';

class DayDetailsScreen extends ConsumerStatefulWidget {
 final DateTime date;
 const DayDetailsScreen({super.key, required this.date});

 @override
 ConsumerState<DayDetailsScreen> createState() => _DayDetailsScreenState();
}

class _DayDetailsScreenState extends ConsumerState<DayDetailsScreen> {
 String? _selectedMood;
 List<String> _selectedSymptoms = [];

 static const List<String> _symptoms = [
 'Cramps', 'Headache', 'Bloating', 'Tiredness', 'Backache', 'Acne',
 ];

 @override
 Widget build(BuildContext context) {
 final predictionAsync = ref.watch(cyclePredictionProvider);
 final recommendationsAsync = ref.watch(recommendationsProvider);

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 leading: IconButton(
 icon: const Icon(Icons.chevron_left_rounded, size: 28),
 onPressed: () => context.pop(),
 ),
 title: const Text('Day Details'),
 ),
 body: SingleChildScrollView(
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // ─── Date Header Card ───
 BloomCard(
 padding: const EdgeInsets.all(20),
 child: Column(
 children: [
 Row(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 const Text(' ', style: TextStyle(fontSize: 20)),
 Text(
 DateFormat('MMMM d, yyyy').format(widget.date),
 style: const TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 color: BloomTheme.darkText,
 ),
 ),
 ],
 ),
 const SizedBox(height: 4),
 predictionAsync.when(
 data: (prediction) => Text(
 'Cycle Day ${prediction.currentCycleDay}',
 style: const TextStyle(fontSize: 13, color: BloomTheme.subText),
 ),
 loading: () => const SizedBox.shrink(),
 error: (_, __) => const SizedBox.shrink(),
 ),
 const SizedBox(height: 12),
 predictionAsync.when(
 data: (prediction) => Row(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 _phaseTag(prediction.currentPhase.displayName, BloomTheme.accentLavender),
 const SizedBox(width: 8),
 _phaseTag('Estimated period window', BloomTheme.secondaryPeach),
 ],
 ),
 loading: () => const SizedBox.shrink(),
 error: (_, __) => const SizedBox.shrink(),
 ),
 ],
 ),
 ),
 const SizedBox(height: 24),

 // ─── How are you feeling? ───
 const Text(
 'How are you feeling?',
 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 14),
 MoodSelectorRow(
 selectedMood: _selectedMood,
 onMoodSelected: (m) => setState(() => _selectedMood = m),
 ),
 const SizedBox(height: 24),

 // ─── Symptoms ───
 const Text(
 'Symptoms',
 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 12),
 Wrap(
 spacing: 8,
 runSpacing: 8,
 children: [
 ..._symptoms.map((symptom) {
 final isSelected = _selectedSymptoms.contains(symptom);
 return FilterChip(
 label: Text(symptom),
 selected: isSelected,
 onSelected: (selected) {
 setState(() {
 if (selected) {
 _selectedSymptoms.add(symptom);
 } else {
 _selectedSymptoms.remove(symptom);
 }
 });
 },
 selectedColor: BloomTheme.primaryRose,
 backgroundColor: Colors.white,
 labelStyle: TextStyle(
 color: isSelected ? Colors.white : BloomTheme.darkText,
 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
 fontSize: 13,
 ),
 side: BorderSide(color: isSelected ? BloomTheme.primaryRose : BloomTheme.borderSoft),
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
 );
 }),
 ActionChip(
 avatar: const Icon(Icons.add, size: 16, color: BloomTheme.primaryRose),
 label: const Text('More'),
 onPressed: () {},
 backgroundColor: Colors.white,
 side: const BorderSide(color: BloomTheme.borderSoft),
 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
 ),
 ],
 ),
 const SizedBox(height: 28),

 // ─── Bloom Suggests ───
 const Text(
 'Bloom suggests',
 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 12),
 recommendationsAsync.when(
 data: (recs) {
 if (recs.isEmpty) return const SizedBox.shrink();
 final rec = recs.first;
 return BloomCard(
 backgroundColor: BloomTheme.warmSun,
 padding: const EdgeInsets.all(16),
 child: Row(
 children: [
 Container(
 width: 50,
 height: 50,
 decoration: BoxDecoration(
 color: Colors.white.withOpacity(0.7),
 shape: BoxShape.circle,
 ),
 child: const Center(child: Text('', style: TextStyle(fontSize: 28))),
 ),
 const SizedBox(width: 14),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 rec.description,
 maxLines: 3,
 overflow: TextOverflow.ellipsis,
 style: TextStyle(fontSize: 13, color: BloomTheme.darkText.withOpacity(0.8), height: 1.4),
 ),
 const SizedBox(height: 8),
 GestureDetector(
 onTap: () {
 if (rec.route != null) context.push(rec.route!);
 },
 child: const Text(
 'View preparation tips →',
 style: TextStyle(
 fontSize: 13,
 fontWeight: FontWeight.bold,
 color: BloomTheme.primaryRose,
 ),
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 );
 },
 loading: () => const SizedBox.shrink(),
 error: (_, __) => const SizedBox.shrink(),
 ),
 const SizedBox(height: 30),
 ],
 ),
 ),
 );
 }

 Widget _phaseTag(String text, Color color) {
 return Container(
 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
 decoration: BoxDecoration(
 color: color,
 borderRadius: BorderRadius.circular(14),
 ),
 child: Text(
 text,
 style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: BloomTheme.darkText),
 ),
 );
 }
}
