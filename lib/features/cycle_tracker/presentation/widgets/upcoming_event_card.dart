import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../core/widgets/bloom_card.dart';
import '../../domain/entities/calendar_event.dart';

class UpcomingEventCard extends StatelessWidget {
 final CalendarEvent event;
 final bool isOverlappingWithPeriod;

 const UpcomingEventCard({
 super.key,
 required this.event,
 this.isOverlappingWithPeriod = false,
 });

 Color _categoryColor() {
 switch (event.category) {
 case EventCategory.exam:
 return BloomTheme.primaryRose;
 case EventCategory.sports:
 return BloomTheme.successGreen;
 case EventCategory.travel:
 return BloomTheme.accentLavender;
 case EventCategory.competition:
 return BloomTheme.warningOrange;
 case EventCategory.school:
 case EventCategory.family:
 case EventCategory.vacation:
 case EventCategory.other:
 return BloomTheme.mintFresh;
 }
 }

 IconData _categoryIcon() {
 switch (event.category) {
 case EventCategory.exam:
 return Icons.menu_book_rounded;
 case EventCategory.sports:
 return Icons.sports_soccer_rounded;
 case EventCategory.travel:
 return Icons.flight_rounded;
 case EventCategory.competition:
 return Icons.emoji_events_rounded;
 case EventCategory.school:
 return Icons.school_rounded;
 case EventCategory.family:
 return Icons.family_restroom_rounded;
 case EventCategory.vacation:
 return Icons.beach_access_rounded;
 case EventCategory.other:
 return Icons.event_rounded;
 }
 }

 String _categoryLabel() {
 return event.category.name.toUpperCase();
 }

 @override
 Widget build(BuildContext context) {
 final catColor = _categoryColor();
 final allDay = event.endDate.difference(event.startDate).inHours >= 24;
 final durationHours = event.endDate.difference(event.startDate).inHours;
 final durationMins = event.endDate.difference(event.startDate).inMinutes % 60;
 final durationStr = durationHours > 0
 ? '$durationHours hrs ${durationMins > 0 ? '$durationMins mins' : ''}'
 : '$durationMins mins';

 return BloomCard(
 backgroundColor: isOverlappingWithPeriod ? BloomTheme.secondaryPeach.withOpacity(0.5) : Colors.white,
 padding: const EdgeInsets.all(16),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // Date badge
 Container(
 width: 50,
 padding: const EdgeInsets.symmetric(vertical: 8),
 decoration: BoxDecoration(
 color: isOverlappingWithPeriod
 ? BloomTheme.primaryRose.withOpacity(0.9)
 : catColor.withOpacity(0.2),
 borderRadius: BorderRadius.circular(14),
 ),
 child: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 Text(
 DateFormat('MMM').format(event.startDate).toUpperCase(),
 style: TextStyle(
 fontSize: 9,
 fontWeight: FontWeight.bold,
 color: isOverlappingWithPeriod ? Colors.white : catColor,
 ),
 ),
 Text(
 DateFormat('dd').format(event.startDate),
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 color: isOverlappingWithPeriod ? Colors.white : catColor,
 ),
 ),
 if (allDay)
 const Icon(Icons.all_inclusive_rounded, size: 10, color: BloomTheme.subText)
 else
 Text(
 DateFormat('hh').format(event.startDate),
 style: TextStyle(
 fontSize: 10,
 color: isOverlappingWithPeriod ? Colors.white70 : BloomTheme.subText,
 ),
 ),
 ],
 ),
 ),
 const SizedBox(width: 14),

 // Event details
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Row(
 children: [
 Icon(_categoryIcon(), size: 16, color: catColor),
 const SizedBox(width: 4),
 Expanded(
 child: Text(
 event.title,
 maxLines: 1,
 overflow: TextOverflow.ellipsis,
 style: const TextStyle(
 fontWeight: FontWeight.bold,
 fontSize: 15,
 color: BloomTheme.darkText,
 ),
 ),
 ),
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
 decoration: BoxDecoration(
 color: catColor.withOpacity(0.2),
 borderRadius: BorderRadius.circular(4),
 ),
 child: Text(
 _categoryLabel(),
 style: TextStyle(
 fontSize: 9,
 fontWeight: FontWeight.bold,
 color: catColor,
 ),
 ),
 ),
 ],
 ),
 const SizedBox(height: 4),
 Text(
 isOverlappingWithPeriod
 ? ' Overlaps with estimated period window'
 : allDay
 ? 'All day event'
 : '$durationStr • ${_formatTimeRange(event.startDate, event.endDate)}',
 style: TextStyle(
 fontSize: 12,
 color: isOverlappingWithPeriod ? BloomTheme.primaryRose : BloomTheme.subText,
 fontWeight:
 isOverlappingWithPeriod ? FontWeight.w600 : FontWeight.normal,
 ),
 ),
 if (!isOverlappingWithPeriod)
 Padding(
 padding: const EdgeInsets.only(top: 4),
 child: Row(
 children: [
 Icon(
 event.source == 'device'
 ? Icons.phone_rounded
 : Icons.edit_calendar_rounded,
 size: 12,
 color: BloomTheme.subText,
 ),
 const SizedBox(width: 4),
 Text(
 'Source: ${event.source == 'device' ? 'Device Calendar' : 'My Calendar'}',
 style: const TextStyle(fontSize: 10, color: BloomTheme.subText),
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 ],
 ),
 if (isOverlappingWithPeriod) ...[
 const SizedBox(height: 8),
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
 decoration: BoxDecoration(
 color: BloomTheme.warmSun.withOpacity(0.5),
 borderRadius: BorderRadius.circular(8),
 ),
 child: Row(
 children: const [
 Icon(Icons.info_outline_rounded, size: 14, color: BloomTheme.primaryRose),
 SizedBox(width: 6),
 Text(
 'Consider bringing extra supplies just in case',
 style: TextStyle(fontSize: 11, color: BloomTheme.darkText),
 ),
 ],
 ),
 ),
 ],
 ],
 ),
 );
 }

 String _formatTimeRange(DateTime start, DateTime end) {
 return '${DateFormat('h:mm a').format(start)} – ${DateFormat('h:mm a').format(end)}';
 }
}
