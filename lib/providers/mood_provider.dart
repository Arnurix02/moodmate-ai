import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoodProvider with ChangeNotifier {
  String? _currentMood;
  List<Map<String, dynamic>> _moodHistory = [];
  
  String? get currentMood => _currentMood;
  List<Map<String, dynamic>> get moodHistory => _moodHistory;
  
  MoodProvider() {
    _loadMoodHistory();
  }
  
  void setMood(String mood) {
    _currentMood = mood;
    _saveMoodToHistory(mood);
    notifyListeners();
  }
  
  Future<void> _saveMoodToHistory(String mood) async {
    final entry = {
      'mood': mood,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _moodHistory.insert(0, entry);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mood_history', jsonEncode(_moodHistory));
  }
  
  Future<void> _loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('mood_history');
    
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _moodHistory = decoded.cast<Map<String, dynamic>>();
      notifyListeners();
    }
  }
}