import 'package:flutter/foundation.dart';
import '../services/cerebras_api_service.dart';
import '../services/database_service.dart';

class ChatProvider with ChangeNotifier {
  final CerebrasApiService _apiService = CerebrasApiService();
  final DatabaseService _dbService = DatabaseService();

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _allChats = [];
  String? _currentChatId;
  bool _isLoading = false;

  List<Map<String, dynamic>> get messages => _messages;
  List<Map<String, dynamic>> get allChats => _allChats;
  String? get currentChatId => _currentChatId;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await _loadChats();
    if (_allChats.isNotEmpty) {
      await _loadCurrentChat();
    }
  }

  Future<void> _loadChats() async {
    _allChats = await _dbService.getAllChats();
    notifyListeners();
  }

  Future<void> _loadCurrentChat() async {
    final currentChat = await _dbService.getCurrentChat();
    if (currentChat != null) {
      _currentChatId = currentChat['id'];
      _messages =
          List<Map<String, dynamic>>.from(currentChat['messages'] ?? []);
      notifyListeners();
    }
  }

  Future<void> createNewChat() async {
    final chatId = await _dbService.createNewChat('Новый чат');
    await switchChat(chatId);
  }

  Future<void> switchChat(String chatId) async {
    await _dbService.setCurrentChat(chatId);
    _currentChatId = chatId;
    _messages = await _dbService.getChatMessages(chatId);
    notifyListeners();
  }

  Future<void> deleteChat(String chatId) async {
    await _dbService.deleteChat(chatId);
    await _loadChats();
    await _loadCurrentChat();
  }

  Future<void> sendMoodMessage(String mood, String language) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentChatId ??= await _dbService.createNewChat('Чат о настроении');

      final response = await _apiService.getMoodSupport(mood, language);

      final aiMessage = {
        'text': response,
        'isUser': false,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _messages.add(aiMessage);

      await _dbService.addMessageToChat(_currentChatId!, aiMessage);
      await _loadChats();
    } catch (e) {
      print('Error sending mood message: $e');
      _messages.add({
        'text': 'Упс! Что-то пошло не так. Попробуй ещё раз! 😊',
        'isUser': false,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text, String language) async {
    if (text.trim().isEmpty) return;

    _currentChatId ??= await _dbService.createNewChat('Новый чат');

    final userMessage = {
      'text': text,
      'isUser': true,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _messages.add(userMessage);
    await _dbService.addMessageToChat(_currentChatId!, userMessage);
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      final history = _messages
          .where((m) => m['text'] != null)
          .take(10)
          .map((m) => {
                'role': m['isUser'] == true ? 'user' : 'assistant',
                'content': m['text'].toString(),
              })
          .toList();

      final response = await _apiService.chat(text, language, history);

      final aiMessage = {
        'text': response,
        'isUser': false,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _messages.add(aiMessage);
      await _dbService.addMessageToChat(_currentChatId!, aiMessage);
      await _loadChats();
    } catch (e) {
      print('Error in sendMessage: $e');
      _messages.add({
        'text': 'Упс! Что-то пошло не так. Попробуй ещё раз! 😊',
        'isUser': false,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
