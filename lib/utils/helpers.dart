import 'package:intl/intl.dart';

class Helpers {
  // Форматирование даты
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'ru').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'ru').format(date);
  }

  // Относительное время
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн назад';
    } else {
      return formatDate(date);
    }
  }

  // Проверка подключения к интернету
  static Future<bool> checkInternetConnection() async {
    try {
      // Простая проверка через HTTP запрос
      return true; // В реальном приложении добавь проверку
    } catch (e) {
      return false;
    }
  }

  static bool isValidInput(String text, {int minLength = 1}) {
    return text.trim().length >= minLength;
  }

  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 6) {
      return 'Доброй ночи';
    } else if (hour < 12) {
      return 'Доброе утро';
    } else if (hour < 18) {
      return 'Добрый день';
    } else {
      return 'Добрый вечер';
    }
  }
}
