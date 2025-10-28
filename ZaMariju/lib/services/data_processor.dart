import 'package:flutter/services.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/chat_parser.dart';
import 'package:gpt_wrapped2/services/chat_analyzer.dart';

/// Main service to process ChatGPT data from ChatFetcher
class DataProcessor {
  /// Process conversations from JSON data
  static Future<ChatStats> processConversationsFromJson(List<dynamic> jsonData) async {
    try {
      // Convert JSON to ConversationData objects
      final conversations = jsonData.map((json) => ConversationData.fromJson(json)).toList();
      return _analyzeConversations(conversations);
    } catch (e) {
      print('Error processing JSON data: $e');
      return ChatStats.empty();
    }
  }

  /// Process ChatGPT data from clipboard (exported by ChatFetcher)
  /// 
  /// Steps:
  /// 1. Read JSON from clipboard (copied from ChatFetcher)
  /// 2. Parse the JSON data
  /// 3. Analyze the data
  /// 4. Return ChatStats
  static Future<ChatStats?> processFromClipboard() async {
    try {
      // Step 1: Read from clipboard
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      
      if (clipboardData == null || clipboardData.text == null || clipboardData.text!.isEmpty) {
        return null; // No data in clipboard
      }

      final jsonString = clipboardData.text!;

      // Step 2: Parse the JSON
      final conversations = await ChatParser.parseJson(jsonString);

      if (conversations.isEmpty) {
        // Try alternative format
        final altConversations = await ChatParser.parseAlternativeFormat(jsonString);
        if (altConversations.isEmpty) {
          throw Exception('No conversations found in clipboard data');
        }
        return _analyzeConversations(altConversations);
      }

      // Step 3: Analyze and return stats
      return _analyzeConversations(conversations);
    } catch (e) {
      print('Error processing clipboard data: $e');
      return null;
    }
  }

  /// Analyze conversations and return comprehensive stats
  static ChatStats _analyzeConversations(List<ConversationData> conversations) {
    // Get basic stats from analyzer
    final stats = ChatAnalyzer.analyze(conversations);

    // Extract all messages for additional calculations
    final allMessages = <MessageData>[];
    for (var conv in conversations) {
      allMessages.addAll(conv.messages);
    }

    if (allMessages.isEmpty) {
      return ChatStats.empty();
    }

    // Calculate additional metrics if needed for extended stats
    // final averageResponseTime = ChatAnalyzer.calculateAverageResponseTime(allMessages);
    // final speedLabel = ChatAnalyzer.getSpeedLabel(averageResponseTime);
    // final totalDays = ChatAnalyzer.countUniqueDays(allMessages);
    // final yearPercentage = ChatAnalyzer.calculateYearPercentage(allMessages);

    // Return enhanced stats with all calculated values
    return ChatStats(
      totalHours: stats.totalHours,
      totalMinutes: stats.totalMinutes,
      messagesPerDay: stats.messagesPerDay,
      longestStreak: stats.longestStreak,
      peakTime: stats.peakTime,
      peakHour: stats.peakHour,
      randomQuestion: stats.randomQuestion,
      mainTopic: stats.mainTopic,
      firstChatDate: stats.firstChatDate,
      lastChatDate: stats.lastChatDate,
      totalConversations: stats.totalConversations,
      totalMessages: stats.totalMessages,
    );
  }

  /// Create demo stats for testing (when no file is uploaded)
  static ChatStats createDemoStats() {
    return ChatStats(
      totalHours: 127,
      totalMinutes: 42,
      messagesPerDay: 47,
      longestStreak: 14,
      peakTime: 'night',
      peakHour: 23,
      randomQuestion: 'How do I stop procrastinating?',
      mainTopic: 'literally',
      firstChatDate: DateTime.now().subtract(const Duration(days: 102)),
      lastChatDate: DateTime.now(),
      totalConversations: 89,
      totalMessages: 1247,
    );
  }
}
