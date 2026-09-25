import 'package:flutter/material.dart';
import '../app/theme.dart';

class MoodSelectorRow extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  static const List<Map<String, dynamic>> moods = [
    {'label': 'Great', 'emoji': '🌟', 'color': Color(0xFFFFF3CD)},
    {'label': 'Good', 'emoji': '😊', 'color': Color(0xFFD1F2EB)},
    {'label': 'Okay', 'emoji': '🙂', 'color': Color(0xFFFFF9E6)},
    {'label': 'Low', 'emoji': '😔', 'color': Color(0xFFFFE5D9)},
    {'label': 'Not good', 'emoji': '🥺', 'color': Color(0xFFFFE0E6)},
  ];

  const MoodSelectorRow({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moods.map((m) {
        final label = m['label'] as String;
        final emoji = m['emoji'] as String;
        final color = m['color'] as Color;
        final isSelected = selectedMood == label;

        return GestureDetector(
          onTap: () => onMoodSelected(label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: BloomTheme.primaryRose, width: 2.5)
                        : Border.all(color: Colors.transparent, width: 2.5),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: BloomTheme.primaryRose.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? BloomTheme.primaryRose : BloomTheme.subText,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
