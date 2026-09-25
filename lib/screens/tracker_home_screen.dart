import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../widgets/bloom_card.dart';
import '../widgets/bloom_avatar.dart';
import '../models/cycle.dart';
import '../widgets/cycle_ring_widget.dart';
import '../widgets/mood_selector_row.dart';

class TrackerHomeScreen extends ConsumerStatefulWidget {
  const TrackerHomeScreen({super.key});

  @override
  ConsumerState<TrackerHomeScreen> createState() => _TrackerHomeScreenState();
}

class _TrackerHomeScreenState extends ConsumerState<TrackerHomeScreen> {
  String? _selectedMood;

  void _onMoodSelected(String mood) {
    setState(() => _selectedMood = mood);
    final now = DateTime.now();
    final checkIn = DailyCheckIn(
      id: const Uuid().v4(),
      userId: 'default_user',
      date: now,
      mood: mood,
      symptoms: [],
      createdAt: now,
    );
    ref.read(cycleRepositoryProvider).saveDailyCheckIn(checkIn);
    ref.invalidate(recommendationsProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feeling $mood — logged! '),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final predictionAsync = ref.watch(cyclePredictionProvider);
    final eventsAsync = ref.watch(calendarEventsProvider);
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Top App Bar ───
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: BloomTheme.secondaryPeach,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BloomTale',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: BloomTheme.darkText,
                        ),
                      ),
                      Text(
                        'Learn • Explore • Grow',
                        style: TextStyle(fontSize: 10, color: BloomTheme.subText),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: BloomTheme.darkText),
                    onPressed: () {},
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: BloomTheme.accentLavender,
                    child: Text('', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ─── Greeting Banner ───
              Consumer(
                builder: (context, ref, child) {
                  final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
                  final avatar = selectedAvatarAsync.asData?.value;
                  final avatarId = avatar?.id ?? 'default_avatar';
                  final avatarName = avatar?.name ?? 'Bloom';

                  return BloomCard(
                    backgroundColor: BloomTheme.secondaryPeach,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hi there,',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: BloomTheme.darkText,
                                ),
                              ),
                              Text(
                                "$avatarName is with you!",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: BloomTheme.darkText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Every step you take\nis part of your beautiful journey ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: BloomTheme.darkText.withValues(alpha: 0.7),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        BloomAvatar(
                          avatarId: avatarId,
                          activity: 'happy',
                          size: 72,
                          showBadge: true,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ─── YOUR CYCLE Card ───
              const Text(
                'YOUR CYCLE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: BloomTheme.subText,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              predictionAsync.when(
                data: (prediction) {
                  final startStr = DateFormat('MMM d').format(prediction.estimatedNextPeriodWindow.start);
                  final endStr = DateFormat('d').format(prediction.estimatedNextPeriodWindow.end);
                  final daysUntilPeriod = prediction.estimatedNextPeriodWindow.start.difference(DateTime.now()).inDays;

                  String phaseDescription;
                  String phaseTip;
                  Color phaseColor;

                  switch (prediction.currentPhase) {
                    case CyclePhase.menstrual:
                      phaseDescription = 'Your body is shedding the uterine lining. This is the start of a new cycle.';
                      phaseTip = 'Rest when you need to. Warm compresses and gentle movement can help with cramps.';
                      phaseColor = BloomTheme.primaryRose;
                      break;
                    case CyclePhase.follicular:
                      phaseDescription = 'Estrogen is rising, follicles are maturing. You may feel more energetic and social.';
                      phaseTip = 'Great time for new projects, learning, and social activities!';
                      phaseColor = const Color(0xFFFBD38D);
                      break;
                    case CyclePhase.ovulation:
                      phaseDescription = 'An egg is released — your fertile window. Energy and confidence often peak now.';
                      phaseTip = 'Perfect for important conversations, presentations, or trying new things.';
                      phaseColor = BloomTheme.mintFresh;
                      break;
                    case CyclePhase.luteal:
                      phaseDescription = 'Progesterone rises to prepare for potential pregnancy. You may feel more introspective.';
                      phaseTip = 'Listen to your body — prioritize sleep, balanced meals, and gentle self-care.';
                      phaseColor = BloomTheme.accentLavender;
                      break;
                  }

                  return BloomCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cycle Ring
                        CycleRingWidget(
                          currentDay: prediction.currentCycleDay,
                          totalDays: prediction.averageCycleLength,
                          currentPhase: prediction.currentPhase,
                          periodLength: prediction.averagePeriodLength,
                          nextPeriodText: '$startStr – $endStr',
                          onTap: () => context.push('/tracker/calendar'),
                        ),
                        const SizedBox(height: 20),

                        // Phase Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: phaseColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: phaseColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(color: phaseColor, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${prediction.currentPhase} Phase • Day ${prediction.currentCycleDay} of ${prediction.averageCycleLength}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: phaseColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                phaseDescription,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: BloomTheme.darkText,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(' ', style: TextStyle(fontSize: 14)),
                                    Expanded(
                                      child: Text(
                                        phaseTip,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: BloomTheme.darkText.withOpacity(0.8),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Cycle Stats Row
                        Row(
                          children: [
                            _cycleStat('Avg Cycle', '${prediction.averageCycleLength} days', BloomTheme.primaryRose),
                            const SizedBox(width: 12),
                            _cycleStat('Avg Period', '${prediction.averagePeriodLength} days', BloomTheme.warningOrange),
                            const SizedBox(width: 12),
                            _cycleStat(
                              daysUntilPeriod > 0 ? 'Next Period' : 'Period Due',
                              daysUntilPeriod > 0 ? 'in $daysUntilPeriod days' : 'today!',
                              daysUntilPeriod <= 3 ? BloomTheme.primaryRose : BloomTheme.mintFresh,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Phase legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _legendDot(BloomTheme.primaryRose, 'Period'),
                            _legendDot(const Color(0xFFFBD38D), 'Follicular'),
                            _legendDot(BloomTheme.mintFresh, 'Ovulation'),
                            _legendDot(BloomTheme.accentLavender, 'Luteal'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: BloomTheme.primaryRose),
                  ),
                ),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 24),

              // ─── Today's Check-in ───
              BloomCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Check-in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: BloomTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'How are you feeling today?',
                      style: TextStyle(fontSize: 13, color: BloomTheme.subText),
                    ),
                    const SizedBox(height: 16),
                    MoodSelectorRow(
                      selectedMood: _selectedMood,
                      onMoodSelected: _onMoodSelected,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ─── Upcoming Events ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: BloomTheme.darkText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/tracker/calendar'),
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: BloomTheme.primaryRose,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return BloomCard(
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No upcoming events yet.', style: TextStyle(color: BloomTheme.subText)),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: events.take(2).map((event) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BloomCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          onTap: () => context.push('/tracker/calendar'),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: BloomTheme.warmSun,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('MMM').format(event.startDate).toUpperCase(),
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: BloomTheme.primaryRose),
                                    ),
                                    Text(
                                      DateFormat('dd').format(event.startDate),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BloomTheme.darkText),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    Text(
                                      '${DateFormat('h:mm a').format(event.startDate)} – ${DateFormat('h:mm a').format(event.endDate)}',
                                      style: const TextStyle(fontSize: 11, color: BloomTheme.subText),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.calendar_today_outlined, size: 18, color: BloomTheme.subText),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(color: BloomTheme.primaryRose),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 24),

              // ─── Bloom Suggests (top recommendation only) ───
              recommendationsAsync.when(
                data: (recs) {
                  if (recs.isEmpty) return const SizedBox.shrink();
                  final rec = recs.first;
                  return BloomCard(
                    backgroundColor: BloomTheme.warmSun,
                    padding: const EdgeInsets.all(16),
                    onTap: () => context.push('/tracker/recommendations'),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Text('', style: TextStyle(fontSize: 20))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rec.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BloomTheme.darkText),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                rec.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: BloomTheme.darkText.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: BloomTheme.primaryRose),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: BloomTheme.subText)),
      ],
    );
  }

  Widget _cycleStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: BloomTheme.subText),
            ),
          ],
        ),
      ),
    );
  }
}
