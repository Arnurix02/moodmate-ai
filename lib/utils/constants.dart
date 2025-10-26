import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'MoodMate AI';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String huggingFaceBaseUrl = 'https://api-inference.huggingface.co/models';
  static const String k2ModelPath = 'K2Model';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String moodHistoryKey = 'mood_history';
  static const String journalEntriesKey = 'journal_entries';
  static const String chatHistoryKey = 'chat_history';
  
  // Breathing Exercise
  static const int breathingCycles = 5;
  static const Duration inhaleTime = Duration(seconds: 4);
  static const Duration exhaleTime = Duration(seconds: 4);
  static const Duration holdTime = Duration(seconds: 2);
  
  // UI Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 20.0;
  
  // Messages
  static const String welcomeMessage = 'Привет! Я твой AI-помощник MoodMate. Расскажи, как у тебя дела? 💜';
  static const String supportMessage = '💜 Помни: всегда можно обратиться к взрослым, которым доверяешь';
  static const String apiKeyMissing = 'API ключ не настроен! Добавь свой Hugging Face API ключ';
  static const String modelLoading = 'Модель загружается... Попробуй через минуту! 🔄';
  static const String connectionError = 'Упс! Проблема с подключением. Проверь интернет 📡';
}
