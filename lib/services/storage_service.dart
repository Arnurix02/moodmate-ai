import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

class StorageService {
  static const String _moodHistoryKey = 'mood_history';
  static const String _journalEntriesKey = 'journal_entries';
  
  Future<List<Map<String, dynamic>>> loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_moodHistoryKey);
    if (data == null) return [];
    
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.cast<Map<String, dynamic>>();
  }
  
  Future<void> saveMoodHistory(List<Map<String, dynamic>> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_moodHistoryKey, jsonEncode(history));
  }
  
  Future<List<JournalEntry>> loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_journalEntriesKey);
    if (data == null) return [];
    
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((json) => JournalEntry.fromJson(json)).toList();
  }
  
  Future<void> saveJournalEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final data = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_journalEntriesKey, jsonEncode(data));
  }
}