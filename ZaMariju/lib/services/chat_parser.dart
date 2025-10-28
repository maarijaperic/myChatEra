import 'dart:convert';
import 'package:gpt_wrapped2/models/chat_data.dart';

/// Parses ChatGPT export JSON files
class ChatParser {
  /// Parse ChatGPT conversations.json export file
  /// 
  /// ChatGPT exports data in this format:
  /// [
  ///   {
  ///     "id": "conv-id",
  ///     "title": "Conversation title",
  ///     "create_time": 1234567890.123,
  ///     "update_time": 1234567890.123,
  ///     "mapping": {
  ///       "message-id": {
  ///         "id": "message-id",
  ///         "message": {
  ///           "author": {"role": "user"},
  ///           "content": {"parts": ["message text"]},
  ///           "create_time": 1234567890.123
  ///         }
  ///       }
  ///     }
  ///   }
  /// ]
  static Future<List<ConversationData>> parseJson(String jsonString) async {
    try {
      final List<dynamic> rawData = json.decode(jsonString);
      final conversations = <ConversationData>[];

      for (var convJson in rawData) {
        try {
          final conversation = _parseConversation(convJson);
          if (conversation.messages.isNotEmpty) {
            conversations.add(conversation);
          }
        } catch (e) {
          print('Error parsing conversation: $e');
          continue;
        }
      }

      return conversations;
    } catch (e) {
      print('Error parsing JSON: $e');
      return [];
    }
  }

  static ConversationData _parseConversation(Map<String, dynamic> json) {
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
        // Try parsing as ISO 8601
        return DateTime.parse(time);
      } catch (_) {
        // Try parsing as Unix timestamp
        try {
          final timestamp = double.parse(time);
          return DateTime.fromMillisecondsSinceEpoch((timestamp * 1000).toInt());
        } catch (_) {
          return DateTime.now();
        }
      }
    }
    return DateTime.now();
  }

  /// Parse alternative JSON formats (if users export differently)
  static Future<List<ConversationData>> parseAlternativeFormat(String jsonString) async {
    try {
      final data = json.decode(jsonString);
      
      // Handle if it's a single conversation
      if (data is Map) {
        return [_parseConversation(Map<String, dynamic>.from(data))];
      }
      
      // Handle if it's a list
      if (data is List) {
        return parseJson(jsonString);
      }
      
      return [];
    } catch (e) {
      print('Error parsing alternative format: $e');
      return [];
    }
  }
}

