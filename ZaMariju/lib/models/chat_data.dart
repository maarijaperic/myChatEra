/// Shared data models for conversation analysis
class ConversationData {
  final String id;
  final String title;
  final DateTime createTime;
  final DateTime updateTime;
  final List<MessageData> messages;

  ConversationData({
    required this.id,
    required this.title,
    required this.createTime,
    required this.updateTime,
    this.messages = const [],
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      id: json['id'] ?? json['conversation_id'] ?? '',
      title: json['title'] ?? 'Untitled',
      createTime: _parseTime(json['create_time'] ?? json['created']),
      updateTime: _parseTime(json['update_time'] ?? json['updated'] ?? json['create_time'] ?? json['created']),
      messages: [],
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
}

class MessageData {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;

  MessageData({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}

/// Analyzed stats from conversations (no AI needed)
class ChatStats {
  final int totalHours;
  final int totalMinutes;
  final int messagesPerDay;
  final int longestStreak;
  final String peakTime; // 'morning', 'afternoon', 'evening', 'night'
  final int peakHour;
  final String? randomQuestion;
  final String? mainTopic;
  final DateTime? firstChatDate;
  final DateTime? lastChatDate;
  final int totalConversations;
  final int totalMessages;
  final int? mostUsedWordCount; // Count of most used word
  final int? totalDays; // Total unique days with chats
  final int? yearPercentage; // Percentage of year with chats
  final double? averageResponseTime; // Average response time in seconds
  final String? speedLabel; // Speed label: 'lightning-fast', 'quick', 'thoughtful', 'patient'

  ChatStats({
    required this.totalHours,
    required this.totalMinutes,
    required this.messagesPerDay,
    required this.longestStreak,
    required this.peakTime,
    required this.peakHour,
    this.randomQuestion,
    this.mainTopic,
    this.firstChatDate,
    this.lastChatDate,
    required this.totalConversations,
    required this.totalMessages,
    this.mostUsedWordCount,
    this.totalDays,
    this.yearPercentage,
    this.averageResponseTime,
    this.speedLabel,
  });

  factory ChatStats.empty() {
    return ChatStats(
      totalHours: 0,
      totalMinutes: 0,
      messagesPerDay: 0,
      longestStreak: 0,
      peakTime: 'night',
      peakHour: 23,
      totalConversations: 0,
      totalMessages: 0,
      mostUsedWordCount: 0,
      totalDays: 0,
      yearPercentage: 0,
      averageResponseTime: 0.0,
      speedLabel: 'thoughtful',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalHours': totalHours,
      'totalMinutes': totalMinutes,
      'messagesPerDay': messagesPerDay,
      'longestStreak': longestStreak,
      'peakTime': peakTime,
      'peakHour': peakHour,
      'randomQuestion': randomQuestion,
      'mainTopic': mainTopic,
      'firstChatDate': firstChatDate?.toIso8601String(),
      'lastChatDate': lastChatDate?.toIso8601String(),
      'totalConversations': totalConversations,
      'totalMessages': totalMessages,
    };
  }

  factory ChatStats.fromJson(Map<String, dynamic> json) {
    return ChatStats(
      totalHours: json['totalHours'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      messagesPerDay: json['messagesPerDay'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      peakTime: json['peakTime'] ?? 'night',
      peakHour: json['peakHour'] ?? 23,
      randomQuestion: json['randomQuestion'],
      mainTopic: json['mainTopic'],
      firstChatDate: json['firstChatDate'] != null ? DateTime.parse(json['firstChatDate']) : null,
      lastChatDate: json['lastChatDate'] != null ? DateTime.parse(json['lastChatDate']) : null,
      totalConversations: json['totalConversations'] ?? 0,
      totalMessages: json['totalMessages'] ?? 0,
    );
  }
}


