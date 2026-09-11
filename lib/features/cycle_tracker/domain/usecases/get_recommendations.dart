import '../entities/calendar_event.dart';
import '../entities/daily_check_in.dart';
import '../entities/period_log.dart';
import '../entities/recommendation.dart';
import 'calculate_prediction.dart';

class GetRecommendations {
 List<Recommendation> execute({
 required List<PeriodLog> periodLogs,
 required List<DailyCheckIn> checkIns,
 required List<CalendarEvent> upcomingEvents,
 }) {
 final List<Recommendation> recommendations = [];
 final now = DateTime.now();
 final today = DateTime(now.year, now.month, now.day);

 final prediction = CalculatePrediction().execute(periodLogs);
 final estWindow = prediction.estimatedNextPeriodWindow;

 final daysUntilPeriod = estWindow.start.difference(today).inDays;

 // 1. Period Prep Recommendation (if period approaching within 5 days)
 if (daysUntilPeriod >= 0 && daysUntilPeriod <= 5) {
 recommendations.add(
 Recommendation(
 id: 'rec_prep_window',
 title: ' A little preparation can help',
 description: 'Your estimated period window is approaching in about $daysUntilPeriod day${daysUntilPeriod == 1 ? '' : 's'}. Keeping a small kit in your bag helps you feel ready.',
 category: RecommendationCategory.periodPreparation,
 actionButtonText: 'Prepare My Kit ',
 route: '/tracker/prep',
 createdAt: now,
 ),
 );
 }

 // 2. Calendar Event Overlap Recommendation
 for (final event in upcomingEvents) {
 final isOverlapping = (event.startDate.isBefore(estWindow.end.add(const Duration(days: 1))) &&
 event.endDate.isAfter(estWindow.start.subtract(const Duration(days: 1))));

 if (isOverlapping) {
 String categoryName = event.title;
 recommendations.add(
 Recommendation(
 id: 'rec_event_${event.id}',
 title: ' Upcoming: $categoryName',
 description: 'Your estimated period window overlaps with $categoryName on ${event.startDate.month}/${event.startDate.day}. You can still fully take part! Preparing beforehand keeps you comfortable.',
 category: RecommendationCategory.calendarPlanning,
 actionButtonText: 'View Prep Checklist ',
 route: '/tracker/prep',
 createdAt: now,
 ),
 );
 break; // Show top overlapping event recommendation
 }
 }

 // 3. Symptom-Based Educational Recommendation
 final recentCheckIns = checkIns.take(3).toList();
 final recentSymptoms = recentCheckIns.expand((c) => c.symptoms).toSet();

 if (recentSymptoms.contains('Cramps')) {
 recommendations.add(
 Recommendation(
 id: 'rec_edu_cramps',
 title: 'Understanding Period Cramps ',
 description: 'Cramps happen when your body naturally contracts during your cycle. Want to learn gentle ways to soothe them?',
 category: RecommendationCategory.education,
 actionButtonText: 'Learn More ',
 route: '/stories/first_period',
 createdAt: now,
 ),
 );
 } else if (recentSymptoms.contains('Acne') || recentSymptoms.contains('Bloating')) {
 recommendations.add(
 Recommendation(
 id: 'rec_edu_skin_body',
 title: 'Why bodies change during puberty',
 description: 'Skin changes and mild bloating are normal shifts as hormones fluctuate in growing bodies.',
 category: RecommendationCategory.education,
 actionButtonText: 'Read Story ',
 route: '/stories/first_period',
 createdAt: now,
 ),
 );
 }

 // 4. Mood / Wellness Recommendation
 final recentMoods = recentCheckIns.map((c) => c.mood).toList();
 if (recentMoods.contains('Tired') || recentMoods.contains('Anxious')) {
 recommendations.add(
 Recommendation(
 id: 'rec_wellness_rest',
 title: 'Gentle Care for Low Energy ',
 description: 'You\'ve logged feeling tired or anxious recently. Warm tea, light stretching, and early sleep can feel wonderful.',
 category: RecommendationCategory.wellness,
 actionButtonText: 'Check-in Insights',
 route: '/tracker/insights',
 createdAt: now,
 ),
 );
 }

 // 5. Ask Bloom AI Integration
 if (recentSymptoms.isNotEmpty || recentMoods.isNotEmpty) {
 recommendations.add(
 Recommendation(
 id: 'rec_ask_bloom',
 title: 'Curious about how you\'re feeling? ',
 description: 'Ask Bloom AI any question about your cycle, moods, or prep in a safe, non-judgmental space.',
 category: RecommendationCategory.bloomAi,
 actionButtonText: 'Ask Bloom ',
 route: '/bloom-ai',
 createdAt: now,
 ),
 );
 }

 // Default recommendation if empty
 if (recommendations.isEmpty) {
 recommendations.add(
 Recommendation(
 id: 'rec_default_welcome',
 title: 'Welcome to your Bloom Tracker ',
 description: 'Check in daily with how you feel or log your periods to build personalized predictions and prep tips.',
 category: RecommendationCategory.wellness,
 actionButtonText: 'Daily Check-in',
 route: '/tracker',
 createdAt: now,
 ),
 );
 }

 return recommendations;
 }
}
