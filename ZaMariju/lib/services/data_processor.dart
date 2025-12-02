import 'package:flutter/services.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/chat_parser.dart';
import 'package:gpt_wrapped2/services/chat_analyzer.dart';
import 'package:gpt_wrapped2/services/stats_calculator.dart';

/// Main service to process ChatGPT data from ChatFetcher
class DataProcessor {
  /// Process conversations from JSON data
  static Future<ChatStats> processConversationsFromJson(List<dynamic> jsonData) async {
    try {
      if (jsonData.isEmpty) {
        print('No conversations in JSON data');
        return ChatStats.empty();
      }

      print('Processing ${jsonData.length} conversations...');
      
      final conversations = parseConversations(jsonData);

      if (conversations.isEmpty) {
        print('No valid conversations parsed');
        return ChatStats.empty();
      }

      print('Successfully parsed ${conversations.length} conversations');
      final stats = analyzeConversations(conversations);
      print('Calculated stats: ${stats.totalConversations} conversations, ${stats.totalMessages} messages');
      return stats;
    } catch (e, stackTrace) {
      print('Error processing JSON data: $e');
      print('Stack trace: $stackTrace');
      return ChatStats.empty();
    }
  }

  /// Convert raw JSON conversation entries into ConversationData objects
  static List<ConversationData> parseConversations(List<dynamic> jsonData) {
    final conversations = <ConversationData>[];
    final seenIds = <String, ConversationData>{};

    for (var json in jsonData) {
      try {
        final jsonMap = json as Map<String, dynamic>;
        final conversationId = (jsonMap['id'] ?? '').toString();

        ConversationData? conv;

        // If we already have simplified messages, parse them directly
        if (jsonMap.containsKey('messages') && jsonMap['messages'] is List) {
          conv = _parseConversationWithMessageList(jsonMap);
        }
        // If we have mapping (full conversation with messages), parse it
        else if (jsonMap.containsKey('mapping') && jsonMap['mapping'] != null) {
          conv = _parseConversationWithMessages(jsonMap);
        } else {
          // Otherwise, just parse metadata
          conv = ConversationData.fromJson(jsonMap);
        }

        if (conv == null) continue;

        // Handle duplicates: keep the one with more messages
        if (seenIds.containsKey(conversationId)) {
          final existing = seenIds[conversationId]!;
          if (conv.messages.length > existing.messages.length) {
            // Replace with version that has more messages
            seenIds[conversationId] = conv;
            print('🔵 PARSER_DEBUG: Replacing duplicate conversation $conversationId (${existing.messages.length} -> ${conv.messages.length} messages)');
          } else {
            // Keep existing version (has more or equal messages)
            print('🔵 PARSER_DEBUG: Skipping duplicate conversation $conversationId (existing has ${existing.messages.length}, new has ${conv.messages.length} messages)');
          }
        } else {
          seenIds[conversationId] = conv;
        }
      } catch (e) {
        print('Error parsing conversation: $e');
        print('Conversation data: $json');
      }
    }

    // Return deduplicated conversations
    final result = seenIds.values.toList();
    print('🔵 PARSER_DEBUG: Parsed ${result.length} unique conversations (removed ${jsonData.length - result.length} duplicates)');
    return result;
  }

  /// Public helper to analyze already parsed conversations
  static ChatStats analyzeConversations(List<ConversationData> conversations) {
    return _analyzeConversations(conversations);
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
        return analyzeConversations(altConversations);
      }

      // Step 3: Analyze and return stats
      return analyzeConversations(conversations);
    } catch (e) {
      print('Error processing clipboard data: $e');
      return null;
    }
  }

  /// Analyze conversations and return comprehensive stats
  static ChatStats _analyzeConversations(List<ConversationData> conversations) {
    if (conversations.isEmpty) {
      return ChatStats.empty();
    }

    // Extract all messages for additional calculations
    final allMessages = <MessageData>[];
    for (var conv in conversations) {
      allMessages.addAll(conv.messages);
    }

    // If we have messages, use ChatAnalyzer (more accurate)
    if (allMessages.isNotEmpty) {
      final stats = ChatAnalyzer.analyze(conversations);
      // Calculate additional metrics
      // ALWAYS recalculate mainTopic from actual messages to ensure accuracy
      var mostUsedWord = ChatAnalyzer.getMostUsedWord(allMessages);
      
      // If still null/empty, try to get from stats as fallback
      if (mostUsedWord == null || mostUsedWord.isEmpty || mostUsedWord.toLowerCase() == 'null') {
        print('🔵 PROCESSOR_DEBUG: getMostUsedWord returned null/empty, trying stats.mainTopic...');
        mostUsedWord = stats.mainTopic;
        // If stats.mainTopic is also null/empty, try one more time with different approach
        if (mostUsedWord == null || mostUsedWord.isEmpty || mostUsedWord.toLowerCase() == 'null') {
          print('🔵 PROCESSOR_DEBUG: stats.mainTopic is also null/empty, recalculating...');
          mostUsedWord = ChatAnalyzer.getMostUsedWord(allMessages);
        }
      }
      
      print('🔵 PROCESSOR_DEBUG: Final mostUsedWord = $mostUsedWord');
      
      final mostUsedWordCount = (mostUsedWord != null && mostUsedWord.isNotEmpty && mostUsedWord.toLowerCase() != 'null')
          ? ChatAnalyzer.getMostUsedWordCount(allMessages, mostUsedWord.toLowerCase())
          : 0;
      
      print('🔵 PROCESSOR_DEBUG: mostUsedWordCount = $mostUsedWordCount');
      final totalDays = ChatAnalyzer.countUniqueDays(allMessages);
      final yearPercentage = ChatAnalyzer.calculateYearPercentage(allMessages);
      final averageResponseTime = ChatAnalyzer.calculateAverageResponseTime(allMessages);
      final speedLabel = ChatAnalyzer.getSpeedLabel(averageResponseTime);
      
      return ChatStats(
        totalHours: stats.totalHours,
        totalMinutes: stats.totalMinutes,
        messagesPerDay: stats.messagesPerDay,
        longestStreak: stats.longestStreak,
        peakTime: stats.peakTime,
        peakHour: stats.peakHour,
        randomQuestion: stats.randomQuestion,
        mainTopic: mostUsedWord, // Always use recalculated word
        firstChatDate: stats.firstChatDate,
        lastChatDate: stats.lastChatDate,
        totalConversations: stats.totalConversations,
        totalMessages: stats.totalMessages,
        // Additional calculated fields
        mostUsedWordCount: mostUsedWordCount,
        totalDays: totalDays,
        yearPercentage: yearPercentage,
        averageResponseTime: averageResponseTime,
        speedLabel: speedLabel,
      );
    }

    // If no messages (API only returned metadata), use StatsCalculator
    // This works with just conversation titles and dates
    return StatsCalculator.calculateStats(conversations);
  }

  /// Parse conversation with messages from mapping structure
  static ConversationData _parseConversationWithMessages(Map<String, dynamic> json) {
    final messages = <MessageData>[];
    
    // Parse mapping to get messages
    final mapping = json['mapping'] as Map<String, dynamic>?;
    if (mapping != null) {
      for (var entry in mapping.values) {
        if (entry is! Map<String, dynamic>) continue;
        
        final messageData = entry['message'];
        if (messageData == null) continue;
        
        try {
          final message = _parseMessage(entry['id'] ?? '', messageData);
          if (message != null) {
            messages.add(message);
          }
        } catch (e) {
          print('Error parsing message: $e');
          continue;
        }
      }
    }

    // Sort messages by timestamp
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ConversationData(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      createTime: _parseTime(json['create_time']),
      updateTime: _parseTime(json['update_time'] ?? json['create_time']),
      messages: messages,
    );
  }

  static ConversationData _parseConversationWithMessageList(Map<String, dynamic> json) {
    final messages = <MessageData>[];
    final messageEntries = json['messages'] as List;

    for (var entry in messageEntries) {
      if (entry is! Map<String, dynamic>) continue;

      final role = (entry['role'] ?? '').toString();
      if (role != 'user' && role != 'assistant') continue;

      final rawContent = entry['content'];
      final content = rawContent is String ? rawContent : rawContent?.toString() ?? '';
      if (content.trim().isEmpty) continue;

      final id = (entry['id'] ?? '').toString();

      messages.add(
        MessageData(
          id: id.isNotEmpty ? id : '${json['id'] ?? ''}-${messages.length}',
          role: role,
          content: content.trim(),
          timestamp: _parseTime(entry['create_time']),
        ),
      );
    }

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ConversationData(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      createTime: _parseTime(json['create_time']),
      updateTime: _parseTime(json['update_time'] ?? json['create_time']),
      messages: messages,
    );
  }

  static MessageData? _parseMessage(String id, Map<String, dynamic> json) {
    // Get author role
    final author = json['author'];
    if (author == null) return null;
    
    String role = 'user';
    if (author is Map) {
      role = author['role'] ?? 'user';
    } else if (author is String) {
      role = author;
    }

    // Only include user and assistant messages
    if (role != 'user' && role != 'assistant') {
      return null;
    }

    // Get content
    final content = json['content'];
    if (content == null) return null;

    String messageText = '';
    if (content is Map) {
      final parts = content['parts'];
      if (parts is List && parts.isNotEmpty) {
        messageText = parts.first?.toString() ?? '';
      } else if (content['text'] != null) {
        messageText = content['text'].toString();
      }
    } else if (content is String) {
      messageText = content;
    }

    if (messageText.isEmpty) return null;

    return MessageData(
      id: id,
      role: role,
      content: messageText,
      timestamp: _parseTime(json['create_time']),
    );
  }

  static DateTime _parseTime(dynamic time) {
    if (time == null) return DateTime.now();
    if (time is DateTime) return time;
    if (time is int) return DateTime.fromMillisecondsSinceEpoch(time * 1000);
    if (time is double) return DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());
    if (time is String) {
      try {
        return DateTime.parse(time);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
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
