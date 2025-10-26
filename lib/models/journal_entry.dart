class JournalEntry {
  final String id;
  final String text;
  final String? mood;
  final DateTime timestamp;
  
  JournalEntry({
    String? id,
    required this.text,
    this.mood,
    DateTime? timestamp,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'mood': mood,
    'timestamp': timestamp.toIso8601String(),
  };
  
  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    text: json['text'],
    mood: json['mood'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
