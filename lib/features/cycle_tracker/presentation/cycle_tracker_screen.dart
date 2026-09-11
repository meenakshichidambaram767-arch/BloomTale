import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/bloom_button.dart';
import '../../../core/widgets/bloom_card.dart';
import '../../../core/widgets/mood_selector.dart';
import '../../../core/widgets/symptom_selector.dart';
import '../domain/entities/period_log.dart';
import '../domain/entities/daily_check_in.dart';

class CycleTrackerScreen extends ConsumerStatefulWidget {
 const CycleTrackerScreen({super.key});

 @override
 ConsumerState<CycleTrackerScreen> createState() => _CycleTrackerScreenState();
}

class _CycleTrackerScreenState extends ConsumerState<CycleTrackerScreen> {
 String _selectedFlow = 'Medium';
 String _selectedMood = 'Happy';
 List<String> _selectedSymptoms = ['Cramps'];
 final _notesController = TextEditingController();

 final List<String> _flowOptions = ['None', 'Spotting', 'Light', 'Medium', 'Heavy'];

 @override
 void dispose() {
 _notesController.dispose();
 super.dispose();
 }

 void _onSaveLog() {
 final now = DateTime.now();
 final log = PeriodLog(
 id: const Uuid().v4(),
 userId: 'default_user',
 startDate: now,
 flow: _selectedFlow,
 notes: _notesController.text.trim(),
 createdAt: now,
 );

 final checkIn = DailyCheckIn(
 id: const Uuid().v4(),
 userId: 'default_user',
 date: now,
 mood: _selectedMood,
 symptoms: _selectedSymptoms,
 notes: _notesController.text.trim(),
 createdAt: now,
 );

 ref.read(cycleTrackerProvider.notifier).addLog(log);
 ref.read(cycleRepositoryProvider).saveDailyCheckIn(checkIn);

 ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('Today\'s entry logged safely! ')),
 );
 }

 @override
 Widget build(BuildContext context) {
 final cycleRepo = ref.watch(cycleRepositoryProvider);

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 title: const Text('Cycle Tracker '),
 actions: [
 IconButton(
 icon: const Icon(Icons.history_rounded),
 onPressed: () => context.push('/tracker/history'),
 )
 ],
 ),
 body: SingleChildScrollView(
 padding: const EdgeInsets.all(20.0),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // Current Cycle Summary Header Card
 FutureBuilder<int>(
 future: cycleRepo.getCurrentCycleDay(),
 builder: (context, snapshot) {
 final day = snapshot.data ?? 14;
 return BloomCard(
 backgroundColor: BloomTheme.warmSun,
 child: Row(
 children: [
 Container(
 padding: const EdgeInsets.all(16),
 decoration: const BoxDecoration(
 color: BloomTheme.primaryRose,
 shape: BoxShape.circle,
 ),
 child: Text(
 'Day\n$day',
 textAlign: TextAlign.center,
 style: const TextStyle(
 color: Colors.white,
 fontWeight: FontWeight.bold,
 fontSize: 16,
 ),
 ),
 ),
 const SizedBox(width: 16),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Text(
 'Cycle Prediction',
 style: TextStyle(
 fontWeight: FontWeight.bold,
 fontSize: 16,
 ),
 ),
 const SizedBox(height: 4),
 FutureBuilder<DateTimeRange?>(
 future: cycleRepo.getEstimatedNextPeriodWindow(),
 builder: (context, dateSnap) {
 final estRange = dateSnap.data;
 final estStr = estRange != null
 ? '${DateFormat('MMM dd').format(estRange.start)} – ${DateFormat('MMM dd').format(estRange.end)}'
 : 'Estimated Soon';
 return Text(
 'Est. Next Period: $estStr',
 style: const TextStyle(
 color: BloomTheme.subText,
 fontSize: 13,
 ),
 );
 },
 ),
 const SizedBox(height: 4),
 const Text(
 '*Estimates only, not a medical guarantee.',
 style: TextStyle(
 fontSize: 10,
 fontStyle: FontStyle.italic,
 color: BloomTheme.subText,
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 );
 },
 ),
 const SizedBox(height: 24),

 // Flow Logging
 Text('Flow Today', style: Theme.of(context).textTheme.titleLarge),
 const SizedBox(height: 10),
 Wrap(
 spacing: 8,
 children: _flowOptions.map((flow) {
 final isSelected = _selectedFlow == flow;
 return ChoiceChip(
 label: Text(flow),
 selected: isSelected,
 onSelected: (_) => setState(() => _selectedFlow = flow),
 selectedColor: BloomTheme.primaryRose,
 backgroundColor: Colors.white,
 labelStyle: TextStyle(
 color: isSelected ? Colors.white : BloomTheme.darkText,
 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
 ),
 );
 }).toList(),
 ),
 const SizedBox(height: 24),

 // Mood Selector
 Text('How do you feel?', style: Theme.of(context).textTheme.titleLarge),
 const SizedBox(height: 10),
 MoodSelector(
 selectedMood: _selectedMood,
 onMoodSelected: (m) => setState(() => _selectedMood = m),
 ),
 const SizedBox(height: 24),

 // Symptoms Selector
 Text('Symptoms', style: Theme.of(context).textTheme.titleLarge),
 const SizedBox(height: 10),
 SymptomSelector(
 selectedSymptoms: _selectedSymptoms,
 onSymptomsChanged: (syms) => setState(() => _selectedSymptoms = syms),
 ),
 const SizedBox(height: 24),

 // Notes Text Input
 Text('Personal Notes', style: Theme.of(context).textTheme.titleLarge),
 const SizedBox(height: 10),
 BloomCard(
 child: TextField(
 controller: _notesController,
 maxLines: 2,
 decoration: const InputDecoration(
 hintText: 'Add private thoughts or feelings...',
 border: InputBorder.none,
 ),
 ),
 ),
 const SizedBox(height: 32),

 BloomButton(
 text: 'Save Today\'s Entry ',
 onPressed: _onSaveLog,
 ),
 ],
 ),
 ),
 );
 }
}
