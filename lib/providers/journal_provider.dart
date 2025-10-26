import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JournalProvider with ChangeNotifier {
  List<Map<String, dynamic>> _entries = [];
  
  List<Map<String, dynamic>> get entries => _entries;
  
  JournalProvider() {
    _loadEntries();
  }
  
  Future<void> addEntry(String text, {String? mood}) async {
    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text,
      'mood': mood,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _entries.insert(0, entry);
    await _saveEntries();
    notifyListeners();
  }
  
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry['id'] == id);
    await _saveEntries();
    notifyListeners();
  }
  
  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('journal_entries');
    
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _entries = decoded.cast<Map<String, dynamic>>();
      notifyListeners();
    }
  }
  
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('journal_entries', jsonEncode(_entries));
  }
}