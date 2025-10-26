import 'dart:convert';
import 'package:http/http.dart' as http;

class CerebrasApiService {
  static const String baseUrl = 'https://api.cerebras.ai/v1/chat/completions';
  static const String apiKey =
      'csk-yenfm9jntj43cxxtd3wh9rwfp56jjktv5hth2f6ee39jkk4t';
  static const String model = 'llama3.1-70b';
  static const Duration timeout = Duration(seconds: 60);

  Future<String> sendMessage(
    String message, {
    String? systemPrompt,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final messages = <Map<String, String>>[];

      if (systemPrompt != null) {
        messages.add({
          'role': 'system',
          'content': systemPrompt,
        });
      }

      // История разговора
      if (conversationHistory != null) {
        messages.addAll(conversationHistory);
      }

      // Текущее сообщение пользователя
      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'messages': messages,
              'max_completion_tokens': 20000,
              'temperature': 0.7,
              'top_p': 0.8,
              'stream': false,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return content ?? 'Извини, не смог сформулировать ответ';
      } else if (response.statusCode == 401) {
        return 'Ошибка API ключа. Проверь настройки!';
      } else if (response.statusCode == 429) {
        return 'Слишком много запросов. Подожди немного! ⏰';
      } else {
        return 'Ошибка: ${response.statusCode}';
      }
    } catch (e) {
      print('Error in CerebrasApiService: $e');
      return 'Упс! Проблема с подключением. Проверь интернет 📡';
    }
  }

  Future<String> getMoodSupport(String mood, String language) async {
    final prompts = {
      'ru': '''Ты заботливый AI-помощник для подростков MoodMate. 
Пользователь выбрал настроение: "$mood".
Дай короткую поддержку (2-3 предложения), будь добрым и понимающим.
Предложи одну полезную активность для улучшения настроения.''',
      'en': '''You are a caring AI assistant for teenagers called MoodMate.
User selected mood: "$mood".
Give brief support (2-3 sentences), be kind and understanding.
Suggest one useful activity to improve mood.''',
      'kk': '''Сіз жасөспірімдер үшін MoodMate AI көмекшісісіз.
Пайдаланушы көңіл-күйін таңдады: "$mood".
Қысқа қолдау көрсетіңіз (2-3 сөйлем), мейірімді және түсінікті болыңыз.
Көңіл-күйді жақсарту үшін бір пайдалы әрекет ұсыныңыз.''',
    };

    return await sendMessage(
      'Расскажи как ты себя чувствуешь сейчас',
      systemPrompt: prompts[language] ?? prompts['ru'],
    );
  }

  Future<String> chat(
    String message,
    String language,
    List<Map<String, String>> history,
  ) async {
    final systemPrompts = {
      'ru': '''Ты дружелюбный AI-помощник MoodMate для подростков.
Помогаешь улучшить настроение, даёшь поддержку и советы.
Будь добрым, понимающим и позитивным.
Отвечай коротко и по делу (2-4 предложения).''',
      'en': '''You are a friendly AI assistant MoodMate for teenagers.
Help improve mood, give support and advice.
Be kind, understanding and positive.
Answer briefly and to the point (2-4 sentences).''',
      'kk': '''Сіз жасөспірімдер үшін MoodMate достық AI көмекшісісіз.
Көңіл-күйді жақсартуға көмектесіңіз, қолдау мен кеңес беріңіз.
Мейірімді, түсінікті және жағымды болыңыз.
Қысқа және нақты жауап беріңіз (2-4 сөйлем).''',
    };

    return await sendMessage(
      message,
      systemPrompt: systemPrompts[language] ?? systemPrompts['ru'],
      conversationHistory: history,
    );
  }

  Future<String> analyzeJournal(String entry, String language) async {
    final prompts = {
      'ru': '''Ты психолог-помощник для подростков.
Проанализируй запись из дневника и дай короткую поддерживающую обратную связь.
Отметь позитивные моменты.''',
      'en': '''You are a psychologist assistant for teenagers.
Analyze the journal entry and give brief supportive feedback.
Note positive moments.''',
      'kk': '''Сіз жасөспірімдерге арналған психолог-көмекшісіз.
Күнделік жазбасын талдаңыз және қысқа қолдаушы кері байланыс беріңіз.
Оң сәттерді атап өтіңіз.''',
    };

    return await sendMessage(
      entry,
      systemPrompt: prompts[language] ?? prompts['ru'],
    );
  }

  Future<bool> checkApiHealth() async {
    try {
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': model,
              'messages': [
                {'role': 'user', 'content': 'test'}
              ],
              'max_completion_tokens': 10,
            }),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
