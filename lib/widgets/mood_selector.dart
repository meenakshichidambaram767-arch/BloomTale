import 'package:flutter/material.dart';
import '../app/theme.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  static const List<Map<String, dynamic>> moods = [
    {'label': 'Happy', 'icon': '😊'},
    {'label': 'Okay', 'icon': '🙂'},
    {'label': 'Sad', 'icon': '😔'},
    {'label': 'Irritated', 'icon': '😤'},
    {'label': 'Anxious', 'icon': '😟'},
    {'label': 'Calm', 'icon': '😌'},
  ];

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: moods.map((m) {
        final label = m['label'] as String;
        final icon = m['icon'] as String;
        final isSelected = selectedMood == label;

        return ChoiceChip(
          label: Text('$icon $label'),
          selected: isSelected,
          onSelected: (_) => onMoodSelected(label),
          selectedColor: BloomTheme.secondaryPeach,
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? BloomTheme.primaryRose : BloomTheme.borderSoft,
            width: isSelected ? 2 : 1,
          ),
          labelStyle: TextStyle(
            color: BloomTheme.darkText,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }
}
