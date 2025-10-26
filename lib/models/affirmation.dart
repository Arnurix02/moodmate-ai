class Affirmation {
  final String id;
  final String text;
  final String emoji;

  const Affirmation({
    required this.id,
    required this.text,
    required this.emoji,
  });

  static const List<Affirmation> all = [
    Affirmation(id: '1', text: 'Ты достоин любви и уважения 💖', emoji: '💖'),
    Affirmation(
        id: '2', text: 'Каждый день - новая возможность 🌅', emoji: '🌅'),
    Affirmation(id: '3', text: 'Твои чувства важны 🤗', emoji: '🤗'),
    Affirmation(id: '4', text: 'Ты сильнее, чем думаешь 💪', emoji: '💪'),
    Affirmation(id: '5', text: 'Ошибки - это часть роста 🌱', emoji: '🌱'),
    Affirmation(id: '6', text: 'Ты можешь попросить о помощи 🤝', emoji: '🤝'),
    Affirmation(id: '7', text: 'Завтра будет лучше ✨', emoji: '✨'),
    Affirmation(id: '8', text: 'Ты уникален и особенен 🦄', emoji: '🦄'),
    Affirmation(id: '9', text: 'Твоё мнение важно 💭', emoji: '💭'),
    Affirmation(id: '10', text: 'Верь в себя 🌈', emoji: '🌈'),
  ];

  static Affirmation getRandom() {
    final index = DateTime.now().millisecond % all.length;
    return all[index];
  }
}
