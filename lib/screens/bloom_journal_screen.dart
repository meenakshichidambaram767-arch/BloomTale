import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';
import '../app/providers.dart';
import '../models/bloom_ai.dart';
import '../widgets/bloom_avatar.dart';

class BloomJournalScreen extends ConsumerStatefulWidget {
  const BloomJournalScreen({super.key});

  @override
  ConsumerState<BloomJournalScreen> createState() => _BloomJournalScreenState();
}

class _BloomJournalScreenState extends ConsumerState<BloomJournalScreen> {
  String _selectedMood = 'Calm';
  final TextEditingController _noteController = TextEditingController();
  BloomJournalEntry? _lastSavedEntry;

  final List<(String, String)> _moodOptions = const [
    ('', 'Happy'),
    ('', 'Calm'),
    ('', 'Worried'),
    ('', 'Stressed'),
    ('', 'Tired'),
    ('', 'Mixed'),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final note = _noteController.text.trim();
    final entry = await ref.read(bloomJournalProvider.notifier).addEntry(_selectedMood, note);
    setState(() {
      _lastSavedEntry = entry;
    });
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BloomTheme.softCream,
      appBar: AppBar(
        title: const Text('Bloom Journal '),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Activity Illustration Banner
          Consumer(
            builder: (context, ref, child) {
              final selectedAvatarAsync = ref.watch(selectedAvatarProvider);
              final avatar = selectedAvatarAsync.asData?.value;
              final avatarId = avatar?.id ?? 'default_avatar';
              final avatarName = avatar?.name ?? 'Bloom';

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BloomIllustrationCard(
                  avatarId: avatarId,
                  activity: 'journaling',
                  height: 180,
                  badgeText: ' Journal Corner',
                  title: '$avatarName\'s Reflection Space',
                  subtitle: 'Take a quiet breath and record your mood and thoughts today.',
                ),
              );
            },
          ),
          // Privacy Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: BloomTheme.warmSun,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 16, color: BloomTheme.primaryRose),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your journal is your safe private space. Entries are stored locally on your device.',
                    style: TextStyle(fontSize: 11, color: BloomTheme.darkText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mood Selector Section
          const Text('How are you feeling today?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BloomTheme.darkText)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _moodOptions.map((opt) {
              final isSelected = opt.$2 == _selectedMood;
              return InkWell(
                onTap: () => setState(() => _selectedMood = opt.$2),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? BloomTheme.primaryRose : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? BloomTheme.primaryRose : BloomTheme.borderSoft),
                    boxShadow: isSelected
                        ? [BoxShadow(color: BloomTheme.primaryRose.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(opt.$1, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(
                        opt.$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : BloomTheme.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Journal Reflection Note Box
          const Text('What\'s on your mind? (Optional note)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BloomTheme.darkText)),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write anything you\'d like about your day, feelings, or body...',
              hintStyle: const TextStyle(fontSize: 13, color: BloomTheme.subText),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: BloomTheme.borderSoft),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: BloomTheme.primaryRose, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _handleSave,
            icon: const Icon(Icons.favorite_rounded, size: 18),
            label: const Text('Save Reflection'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 24),

          // Bloom Reflection Feedback Box
          if (_lastSavedEntry != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BloomTheme.secondaryPeach),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(' ', style: TextStyle(fontSize: 18)),
                      Text('Bloom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: BloomTheme.primaryRose)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_lastSavedEntry!.bloomFeedback ?? 'Thanks for checking in with yourself!', style: const TextStyle(fontSize: 14, color: BloomTheme.darkText, height: 1.4)),
                  const SizedBox(height: 12),
                  const Text('Would you like to:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BloomTheme.subText)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.push('/bloom/chat?source=journal&mood=$_selectedMood'),
                        child: const Text('Talk to Bloom', style: TextStyle(fontSize: 12)),
                      ),
                      OutlinedButton(
                        onPressed: () => context.push('/bloom/tell-someone'),
                        child: const Text('Tell someone', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
