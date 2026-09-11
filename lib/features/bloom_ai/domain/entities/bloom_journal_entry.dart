class BloomJournalEntry {
 final String id;
 final String mood; // Happy, Calm, Worried, Stressed, Tired, Mixed
 final String note;
 final DateTime timestamp;
 final String? bloomFeedback;

 const BloomJournalEntry({
 required this.id,
 required this.mood,
 required this.note,
 required this.timestamp,
 this.bloomFeedback,
 });
}
