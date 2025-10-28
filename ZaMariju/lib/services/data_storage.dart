import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_data.dart';

/// Simple data storage for chat stats
class DataStorage {
  static const String _statsKey = 'chat_stats';
  static const String _conversationsKey = 'conversations_data';

  /// Save calculated stats
  static Future<void> saveStats(ChatStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(stats.toJson());
    await prefs.setString(_statsKey, jsonStr);
  }

  /// Load saved stats
  static Future<ChatStats?> loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_statsKey);
      if (jsonStr == null) return null;
      
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ChatStats.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Save conversation data (for future use)
  static Future<void> saveConversations(List<ConversationData> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = conversations.map((c) => {
      'id': c.id,
      'title': c.title,
      'create_time': c.createTime.toIso8601String(),
      'update_time': c.updateTime.toIso8601String(),
    }).toList();
    final jsonStr = jsonEncode(jsonList);
    await prefs.setString(_conversationsKey, jsonStr);
  }

  /// Load saved conversations
  static Future<List<ConversationData>> loadConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_conversationsKey);
      if (jsonStr == null) return [];
      
      final jsonList = jsonDecode(jsonStr) as List;
      return jsonList.map((json) => ConversationData.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Check if we have saved data
  static Future<bool> hasData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_statsKey);
  }

  /// Clear all saved data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_conversationsKey);
  }
}


