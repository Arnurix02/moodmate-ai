import 'dart:ui';

class Mood {
  final String name;
  final String emoji;
  final Color color;
  
  const Mood({
    required this.name,
    required this.emoji,
    required this.color,
  });
  
  static const List<Mood> moods = [
    Mood(name: 'Отлично', emoji: '😊', color: Color(0xFF4CAF50)),
    Mood(name: 'Хорошо', emoji: '🙂', color: Color(0xFF8BC34A)),
    Mood(name: 'Нормально', emoji: '😐', color: Color(0xFFFFC107)),
    Mood(name: 'Грустно', emoji: '😢', color: Color(0xFF2196F3)),
    Mood(name: 'Плохо', emoji: '😞', color: Color(0xFF9C27B0)),
  ];
}
