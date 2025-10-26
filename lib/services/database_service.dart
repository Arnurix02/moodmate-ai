import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'language_service.dart';

class DatabaseService {
  static const String _userIdKey = 'user_id';
  static const String _userCreatedKey = 'user_created_at';
  static const String _chatsKey = 'chats';
  static const String _currentChatKey = 'current_chat_id';

  Future<String> initializeUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_userIdKey);

    if (userId == null) {
      userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_userIdKey, userId);
      await prefs.setString(_userCreatedKey, DateTime.now().toIso8601String());

      await createNewChat(AppTexts.newChat);
    }

    return userId;
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<DateTime?> getUserCreatedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_userCreatedKey);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  Future<String> createNewChat(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final chatId = 'chat_${DateTime.now().millisecondsSinceEpoch}';

    final chat = {
      'id': chatId,
      'title': title,
      'created_at': DateTime.now().toIso8601String(),
      'messages': <Map<String, dynamic>>[],
    };

    final chatsData = prefs.getString(_chatsKey);
    final List<dynamic> chats = chatsData != null ? jsonDecode(chatsData) : [];

    chats.insert(0, chat);

    await prefs.setString(_chatsKey, jsonEncode(chats));
    await prefs.setString(_currentChatKey, chatId);

    return chatId;
  }

  Future<List<Map<String, dynamic>>> getAllChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatsData = prefs.getString(_chatsKey);

    if (chatsData == null) return [];

    final List<dynamic> chats = jsonDecode(chatsData);
    return chats.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getCurrentChat() async {
    final prefs = await SharedPreferences.getInstance();
    final currentChatId = prefs.getString(_currentChatKey);

    if (currentChatId == null) return null;

    final chats = await getAllChats();
    try {
      return chats.firstWhere((chat) => chat['id'] == currentChatId);
    } catch (e) {
      return null;
    }
  }

  Future<void> setCurrentChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentChatKey, chatId);
  }

  Future<void> addMessageToChat(
      String chatId, Map<String, dynamic> message) async {
    final prefs = await SharedPreferences.getInstance();
    final chats = await getAllChats();

    for (var chat in chats) {
      if (chat['id'] == chatId) {
        final List<dynamic> messages = chat['messages'] ?? [];
        messages.add(message);
        chat['messages'] = messages;

        if (messages.where((m) => m['isUser'] == true).length == 1 &&
            message['isUser'] == true) {
          chat['title'] = message['text'].length > 30
              ? '${message['text'].substring(0, 30)}...'
              : message['text'];
        }

        break;
      }
    }

    await prefs.setString(_chatsKey, jsonEncode(chats));
  }

  Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    final chats = await getAllChats();

    for (var chat in chats) {
      if (chat['id'] == chatId) {
        final messages = chat['messages'] as List<dynamic>?;
        return messages?.cast<Map<String, dynamic>>() ?? [];
      }
    }

    return [];
  }

  Future<void> deleteChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final chats = await getAllChats();

    chats.removeWhere((chat) => chat['id'] == chatId);

    await prefs.setString(_chatsKey, jsonEncode(chats));

    final currentChatId = prefs.getString(_currentChatKey);
    if (currentChatId == chatId) {
      if (chats.isNotEmpty) {
        await setCurrentChat(chats.first['id']);
      } else {
        await createNewChat(AppTexts.newChat);
      }
    }
  }

  Future<void> renameChat(String chatId, String newTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final chats = await getAllChats();

    for (var chat in chats) {
      if (chat['id'] == chatId) {
        chat['title'] = newTitle;
        break;
      }
    }

    await prefs.setString(_chatsKey, jsonEncode(chats));
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
