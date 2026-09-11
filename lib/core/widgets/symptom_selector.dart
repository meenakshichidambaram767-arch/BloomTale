import 'package:flutter/material.dart';
import '../../app/theme.dart';

class SymptomSelector extends StatelessWidget {
 final List<String> selectedSymptoms;
 final ValueChanged<List<String>> onSymptomsChanged;

 static const List<String> availableSymptoms = [
 'Cramps',
 'Headache',
 'Tiredness',
 'Bloating',
 'Mood Changes',
 'Backache',
 'Breast Tenderness',
 'Acne',
 ];

 const SymptomSelector({
 super.key,
 required this.selectedSymptoms,
 required this.onSymptomsChanged,
 });

 @override
 Widget build(BuildContext context) {
 return Wrap(
 spacing: 8,
 runSpacing: 8,
 children: availableSymptoms.map((symptom) {
 final isSelected = selectedSymptoms.contains(symptom);
 return FilterChip(
 label: Text(symptom),
 selected: isSelected,
 onSelected: (selected) {
 final updated = List<String>.from(selectedSymptoms);
 if (selected) {
 updated.add(symptom);
 } else {
 updated.remove(symptom);
 }
 onSymptomsChanged(updated);
 },
 selectedColor: BloomTheme.accentLavender,
 backgroundColor: Colors.white,
 side: BorderSide(
 color: isSelected ? BloomTheme.primaryRose : BloomTheme.borderSoft,
 ),
 labelStyle: TextStyle(
 color: BloomTheme.darkText,
 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
 fontSize: 13,
 ),
 shape: RoundedRectangleBorder(
 borderRadius: BorderRadius.circular(20),
 ),
 );
 }).toList(),
 );
 }
}
