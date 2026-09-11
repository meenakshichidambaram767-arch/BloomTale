import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/bloom_card.dart';

class TrackerCalendarScreen extends ConsumerStatefulWidget {
 const TrackerCalendarScreen({super.key});

 @override
 ConsumerState<TrackerCalendarScreen> createState() => _TrackerCalendarScreenState();
}

class _TrackerCalendarScreenState extends ConsumerState<TrackerCalendarScreen> {
 DateTime _focusedMonth = DateTime.now();

 @override
 Widget build(BuildContext context) {
 final predictionAsync = ref.watch(cyclePredictionProvider);
 final eventsAsync = ref.watch(calendarEventsProvider);
 final logsAsync = ref.watch(periodLogsProvider);

 return Scaffold(
 backgroundColor: BloomTheme.softCream,
 appBar: AppBar(
 leading: IconButton(
 icon: const Icon(Icons.chevron_left_rounded, size: 28),
 onPressed: () => context.pop(),
 ),
 title: Row(
 mainAxisSize: MainAxisSize.min,
 children: const [
 Icon(Icons.calendar_today_rounded, size: 18, color: BloomTheme.darkText),
 SizedBox(width: 8),
 Text('Calendar'),
 ],
 ),
 ),
 body: SingleChildScrollView(
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // ─── Month Switcher ───
 Row(
 mainAxisAlignment: MainAxisAlignment.spaceBetween,
 children: [
 IconButton(
 icon: const Icon(Icons.chevron_left_rounded),
 onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1)),
 ),
 Text(
 DateFormat('MMMM yyyy').format(_focusedMonth),
 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: BloomTheme.darkText),
 ),
 IconButton(
 icon: const Icon(Icons.chevron_right_rounded),
 onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1)),
 ),
 ],
 ),
 const SizedBox(height: 8),

 // ─── Day of Week Headers ───
 BloomCard(
 padding: const EdgeInsets.all(16),
 child: predictionAsync.when(
 data: (prediction) => logsAsync.when(
 data: (logs) {
 final daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
 final firstDayOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7; // Sun=0
 final estStart = prediction.estimatedNextPeriodWindow.start;
 final estEnd = prediction.estimatedNextPeriodWindow.end;
 final now = DateTime.now();
 final today = DateTime(now.year, now.month, now.day);

 return Column(
 children: [
 Row(
 mainAxisAlignment: MainAxisAlignment.spaceAround,
 children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
 .map((d) => SizedBox(
 width: 36,
 child: Center(
 child: Text(d, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: BloomTheme.subText)),
 ),
 ))
 .toList(),
 ),
 const SizedBox(height: 8),
 GridView.builder(
 shrinkWrap: true,
 physics: const NeverScrollableScrollPhysics(),
 itemCount: daysInMonth + firstDayOffset,
 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
 crossAxisCount: 7,
 mainAxisSpacing: 4,
 crossAxisSpacing: 4,
 ),
 itemBuilder: (context, index) {
 if (index < firstDayOffset) return const SizedBox();
 final dayNum = index - firstDayOffset + 1;
 final currentDate = DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);

 bool isPeriodDay = false;
 for (final log in logs) {
 final logStart = DateTime(log.startDate.year, log.startDate.month, log.startDate.day);
 final logEnd = log.endDate != null
 ? DateTime(log.endDate!.year, log.endDate!.month, log.endDate!.day)
 : logStart;
 if (!currentDate.isBefore(logStart) && !currentDate.isAfter(logEnd)) {
 isPeriodDay = true;
 break;
 }
 }

 final isEstimated = !currentDate.isBefore(DateTime(estStart.year, estStart.month, estStart.day)) &&
 !currentDate.isAfter(DateTime(estEnd.year, estEnd.month, estEnd.day));
 final isToday = currentDate == today;

 Color? cellBg;
 Color textColor = BloomTheme.darkText;
 BoxBorder? border;

 if (isPeriodDay) {
 cellBg = BloomTheme.primaryRose;
 textColor = Colors.white;
 } else if (isEstimated) {
 cellBg = BloomTheme.secondaryPeach;
 }

 if (isToday) {
 border = Border.all(color: BloomTheme.primaryRose, width: 2);
 }

 return GestureDetector(
 onTap: () => context.push('/tracker/day/${currentDate.toIso8601String()}'),
 child: Container(
 decoration: BoxDecoration(
 color: cellBg,
 shape: BoxShape.circle,
 border: border,
 ),
 alignment: Alignment.center,
 child: Text(
 '$dayNum',
 style: TextStyle(
 fontWeight: isPeriodDay || isToday ? FontWeight.bold : FontWeight.normal,
 fontSize: 13,
 color: textColor,
 ),
 ),
 ),
 );
 },
 ),
 ],
 );
 },
 loading: () => const Center(child: CircularProgressIndicator(color: BloomTheme.primaryRose)),
 error: (e, _) => Text('$e'),
 ),
 loading: () => const Center(child: CircularProgressIndicator(color: BloomTheme.primaryRose)),
 error: (e, _) => Text('$e'),
 ),
 ),
 const SizedBox(height: 12),

 // ─── Legend ───
 Row(
 mainAxisAlignment: MainAxisAlignment.spaceAround,
 children: [
 _dot(BloomTheme.primaryRose, 'Period'),
 _dot(BloomTheme.secondaryPeach, 'Estimated'),
 _dot(BloomTheme.mintFresh, 'Ovulation'),
 ],
 ),
 const SizedBox(height: 6),
 Row(
 mainAxisAlignment: MainAxisAlignment.spaceAround,
 children: [
 _dot(BloomTheme.accentLavender, 'Mood'),
 _dot(BloomTheme.warningOrange, 'Symptoms'),
 _dot(BloomTheme.successGreen, 'Event'),
 ],
 ),
 const SizedBox(height: 24),

 // ─── Today's Events List ───
 Text(
 'Today – ${DateFormat('MMM d').format(DateTime.now())}',
 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: BloomTheme.darkText),
 ),
 const SizedBox(height: 12),
 eventsAsync.when(
 data: (events) {
 if (events.isEmpty) {
 return const Padding(
 padding: EdgeInsets.all(12),
 child: Text('No events for today.', style: TextStyle(color: BloomTheme.subText)),
 );
 }
 return Column(
 children: events.take(3).map((event) {
 return Padding(
 padding: const EdgeInsets.only(bottom: 8),
 child: BloomCard(
 padding: const EdgeInsets.all(14),
 child: Row(
 children: [
 Container(
 width: 36,
 height: 36,
 decoration: BoxDecoration(
 color: BloomTheme.accentLavender.withOpacity(0.4),
 borderRadius: BorderRadius.circular(10),
 ),
 child: const Center(child: Text('', style: TextStyle(fontSize: 16))),
 ),
 const SizedBox(width: 12),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
 Text(
 '${DateFormat('h:mm a').format(event.startDate)} – ${DateFormat('h:mm a').format(event.endDate)}',
 style: const TextStyle(fontSize: 11, color: BloomTheme.subText),
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 );
 }).toList(),
 );
 },
 loading: () => const CircularProgressIndicator(color: BloomTheme.primaryRose),
 error: (e, _) => Text('$e'),
 ),
 const SizedBox(height: 30),
 ],
 ),
 ),
 floatingActionButton: FloatingActionButton(
 backgroundColor: BloomTheme.primaryRose,
 child: const Icon(Icons.add, color: Colors.white),
 onPressed: () => context.push('/tracker/checkin'),
 ),
 );
 }

 Widget _dot(Color color, String label) {
 return Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
 const SizedBox(width: 4),
 Text(label, style: const TextStyle(fontSize: 10, color: BloomTheme.subText)),
 ],
 );
 }
}
