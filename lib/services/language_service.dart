import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static LanguageService? _instance;
  static LanguageService get instance {
    _instance ??= LanguageService._();
    return _instance!;
  }

  LanguageService._();

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'en';
  }

  Future<void> setLanguage(String lang) async {
    _currentLanguage = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  String translate(Map<String, String> translations) {
    return translations[_currentLanguage] ?? translations['en'] ?? '';
  }
}

String tr(Map<String, String> translations) {
  return LanguageService.instance.translate(translations);
}

class AppTexts {
  static String get newChat => tr({
        'ru': 'Новый чат',
        'en': 'New Chat',
        'kk': 'Жаңа чат',
      });

  static String get moodChat => tr({
        'ru': 'Чат о настроении',
        'en': 'Mood Chat',
        'kk': 'Көңіл-күй чаты',
      });

  // Меню
  static String get breathing => tr({
        'ru': 'Дыхание',
        'en': 'Breathing',
        'kk': 'Тыныс алу',
      });

  static String get journal => tr({
        'ru': 'Дневник',
        'en': 'Journal',
        'kk': 'Күнделік',
      });

  static String get affirmations => tr({
        'ru': 'Аффирмации',
        'en': 'Affirmations',
        'kk': 'Аффирмациялар',
      });

  // Сообщения
  static String get aiThinking => tr({
        'ru': 'AI думает...',
        'en': 'AI is thinking...',
        'kk': 'AI ойлануда...',
      });

  static String get writeMessage => tr({
        'ru': 'Напиши сообщение...',
        'en': 'Write a message...',
        'kk': 'Хабарлама жазыңыз...',
      });

  static String get startConversation => tr({
        'ru': 'Начни разговор!',
        'en': 'Start conversation!',
        'kk': 'Әңгімені бастаңыз!',
      });

  static String get tellMeAboutDay => tr({
        'ru': 'Расскажи мне о своём дне',
        'en': 'Tell me about your day',
        'kk': 'Күніңіз туралы айтыңыз',
      });

  static String get noChats => tr({
        'ru': 'Нет чатов',
        'en': 'No chats',
        'kk': 'Чат жоқ',
      });

  // Дыхание
  static String get breathingExercise => tr({
        'ru': 'Упражнение 4-2-4-2',
        'en': 'Exercise 4-2-4-2',
        'kk': '4-2-4-2 жаттығуы',
      });

  static String get start => tr({
        'ru': 'Начать',
        'en': 'Start',
        'kk': 'Бастау',
      });

  static String get again => tr({
        'ru': 'Ещё раз',
        'en': 'Again',
        'kk': 'Тағы да',
      });

  static String get great => tr({
        'ru': 'Отлично!',
        'en': 'Great!',
        'kk': 'Керемет!',
      });

  static String get inhale => tr({
        'ru': 'Вдох...',
        'en': 'Breathe in...',
        'kk': 'Дем алыңыз...',
      });

  static String get hold => tr({
        'ru': 'Задержи...',
        'en': 'Hold...',
        'kk': 'Ұстаңыз...',
      });

  static String get exhale => tr({
        'ru': 'Выдох...',
        'en': 'Breathe out...',
        'kk': 'Дем шығарыңыз...',
      });

  static String cycle(int current) => tr({
        'ru': 'Цикл $current из 5',
        'en': 'Cycle $current of 5',
        'kk': 'Цикл $current дан 5',
      });

  // Дневник
  static String get emotionJournal => tr({
        'ru': 'Дневник эмоций',
        'en': 'Emotion Journal',
        'kk': 'Эмоция күнделігі',
      });

  static String get howWasDay => tr({
        'ru': 'Как прошёл твой день?',
        'en': 'How was your day?',
        'kk': 'Күніңіз қалай өтті?',
      });

  static String get whatDoYouFeel => tr({
        'ru': 'Что ты чувствуешь?',
        'en': 'What do you feel?',
        'kk': 'Не сезінесіз?',
      });

  static String get saveEntry => tr({
        'ru': 'Сохранить запись',
        'en': 'Save Entry',
        'kk': 'Жазбаны сақтау',
      });

  static String get entrySaved => tr({
        'ru': 'Запись сохранена! 💜',
        'en': 'Entry saved! 💜',
        'kk': 'Жазба сақталды! 💜',
      });

  static String get noEntries => tr({
        'ru': 'Пока нет записей',
        'en': 'No entries yet',
        'kk': 'Әзірше жазба жоқ',
      });

  static String get next => tr({
        'ru': 'Следующая',
        'en': 'Next',
        'kk': 'Келесі',
      });

  static String get connectionError => tr({
        'ru': 'Упс! Проблема с подключением. Проверь интернет 📡',
        'en': 'Oops! Connection problem. Check internet 📡',
        'kk': 'Қате! Байланыс мәселесі. Интернетті тексеріңіз 📡',
      });

  static String get tryAgain => tr({
        'ru': 'Упс! Что-то пошло не так. Попробуй ещё раз! 😊',
        'en': 'Oops! Something went wrong. Try again! 😊',
        'kk': 'Қате! Бір нәрсе дұрыс болмады. Қайталап көріңіз! 😊',
      });
}
