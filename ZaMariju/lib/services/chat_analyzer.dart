import 'package:gpt_wrapped2/models/chat_data.dart';

/// Analyzes ChatGPT conversation data and calculates all statistics
/// No API calls needed - pure data analysis
class ChatAnalyzer {
  /// Analyzes a list of conversations and returns comprehensive stats
  static ChatStats analyze(List<ConversationData> conversations) {
    if (conversations.isEmpty) {
      return ChatStats.empty();
    }

    // Extract all messages from all conversations
    final allMessages = <MessageData>[];
    for (var conv in conversations) {
      allMessages.addAll(conv.messages);
    }

    if (allMessages.isEmpty) {
      return ChatStats.empty();
    }

    // Sort messages by timestamp
    allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return ChatStats(
      totalHours: _calculateTotalHours(allMessages),
      totalMinutes: _calculateTotalMinutes(allMessages),
      messagesPerDay: _calculateMessagesPerDay(allMessages),
      longestStreak: _calculateLongestStreak(allMessages),
      peakTime: _calculatePeakTime(allMessages),
      peakHour: _calculatePeakHour(allMessages),
      randomQuestion: _getFirstUserMessage(allMessages),
      mainTopic: getMostUsedWord(allMessages),
      firstChatDate: allMessages.first.timestamp,
      lastChatDate: allMessages.last.timestamp,
      totalConversations: conversations.length,
      totalMessages: allMessages.length,
    );
  }

  /// Calculate total hours spent chatting
  static int _calculateTotalHours(List<MessageData> messages) {
    if (messages.isEmpty) return 0;
    
    final firstMessage = messages.first.timestamp;
    final lastMessage = messages.last.timestamp;
    final duration = lastMessage.difference(firstMessage);
    
    // Estimate: assume average conversation is 10 minutes
    // Better: group by conversation and sum durations
    return duration.inHours;
  }

  /// Calculate total minutes (remainder after hours)
  static int _calculateTotalMinutes(List<MessageData> messages) {
    if (messages.isEmpty) return 0;
    
    final firstMessage = messages.first.timestamp;
    final lastMessage = messages.last.timestamp;
    final duration = lastMessage.difference(firstMessage);
    
    return duration.inMinutes % 60;
  }

  /// Calculate average messages per day
  static int _calculateMessagesPerDay(List<MessageData> messages) {
    if (messages.isEmpty) return 0;

    final uniqueDays = _getUniqueDays(messages);
    if (uniqueDays.isEmpty) return 0;

    return (messages.length / uniqueDays.length).round();
  }

  /// Calculate longest consecutive streak of days with messages
  static int _calculateLongestStreak(List<MessageData> messages) {
    if (messages.isEmpty) return 0;

    final uniqueDays = _getUniqueDays(messages);
    if (uniqueDays.isEmpty) return 0;

    // Sort days
    uniqueDays.sort();

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < uniqueDays.length; i++) {
      final diff = uniqueDays[i].difference(uniqueDays[i - 1]).inDays;
      
      if (diff == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 1;
      }
    }

    return longestStreak;
  }

  /// Get unique days when user chatted
  static List<DateTime> _getUniqueDays(List<MessageData> messages) {
    final daysSet = <String>{};
    
    for (var message in messages) {
      final dateKey = '${message.timestamp.year}-${message.timestamp.month}-${message.timestamp.day}';
      daysSet.add(dateKey);
    }

    return daysSet.map((dateKey) {
      final parts = dateKey.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toList();
  }

  /// Calculate peak time of day (morning, afternoon, evening, night)
  static String _calculatePeakTime(List<MessageData> messages) {
    if (messages.isEmpty) return 'night';

    final hourCounts = <int, int>{};
    
    for (var message in messages) {
      final hour = message.timestamp.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    // Find hour with most messages
    int peakHour = 0;
    int maxCount = 0;
    
    hourCounts.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        peakHour = hour;
      }
    });

    // Convert to time of day
    if (peakHour >= 5 && peakHour < 12) {
      return 'morning';
    } else if (peakHour >= 12 && peakHour < 17) {
      return 'afternoon';
    } else if (peakHour >= 17 && peakHour < 21) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  /// Calculate peak hour (0-23)
  static int _calculatePeakHour(List<MessageData> messages) {
    if (messages.isEmpty) return 23;

    final hourCounts = <int, int>{};
    
    for (var message in messages) {
      final hour = message.timestamp.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    // Find hour with most messages
    int peakHour = 0;
    int maxCount = 0;
    
    hourCounts.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        peakHour = hour;
      }
    });

    return peakHour;
  }

  /// Get the first user message (for "Where It All Began" screen)
  static String? _getFirstUserMessage(List<MessageData> messages) {
    for (var message in messages) {
      if (message.isUser && message.content.trim().isNotEmpty) {
        return message.content.trim();
      }
    }
    return null;
  }

  /// Get most used word (for "Your Signature Word" screen)
  static String? getMostUsedWord(List<MessageData> messages) {
    final wordCounts = <String, int>{};
    
    // Common words to ignore
    final stopWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'be',
      'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will',
      'would', 'could', 'should', 'may', 'might', 'must', 'can', 'i', 'you',
      'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us', 'them',
      'my', 'your', 'his', 'hers', 'its', 'our', 'their', 'this', 'that',
      'these', 'those', 'what', 'which', 'who', 'when', 'where', 'why', 'how',
    };

    // Only analyze user messages
    for (var message in messages) {
      if (message.isUser) {
        // Split into words and count
        final words = message.content
            .toLowerCase()
            .replaceAll(RegExp(r'[^\w\s]'), '')
            .split(RegExp(r'\s+'));
        
        for (var word in words) {
          if (word.length > 3 && !stopWords.contains(word)) {
            wordCounts[word] = (wordCounts[word] ?? 0) + 1;
          }
        }
      }
    }

    if (wordCounts.isEmpty) return null;

    // Find most common word
    String? mostUsedWord;
    int maxCount = 0;
    
    wordCounts.forEach((word, count) {
      if (count > maxCount) {
        maxCount = count;
        mostUsedWord = word;
      }
    });

    return mostUsedWord;
  }

  /// Calculate average response time (for "Speed of Response" screen)
  static double calculateAverageResponseTime(List<MessageData> messages) {
    if (messages.length < 2) return 0.0;

    final responseTimes = <Duration>[];
    
    for (int i = 0; i < messages.length - 1; i++) {
      // If current is user and next is assistant, calculate response time
      if (messages[i].isUser && messages[i + 1].isAssistant) {
        final responseTime = messages[i + 1].timestamp.difference(messages[i].timestamp);
        responseTimes.add(responseTime);
      }
    }

    if (responseTimes.isEmpty) return 0.0;

    // Calculate average in seconds
    final totalSeconds = responseTimes.fold<int>(0, (sum, duration) => sum + duration.inSeconds);
    return totalSeconds / responseTimes.length;
  }

  /// Get speed label based on average response time
  static String getSpeedLabel(double averageSeconds) {
    if (averageSeconds < 5) {
      return 'lightning-fast';
    } else if (averageSeconds < 10) {
      return 'quick';
    } else if (averageSeconds < 30) {
      return 'thoughtful';
    } else {
      return 'patient';
    }
  }

  /// Count total unique days with chats
  static int countUniqueDays(List<MessageData> messages) {
    return _getUniqueDays(messages).length;
  }

  /// Calculate percentage of year with chats
  static int calculateYearPercentage(List<MessageData> messages) {
    final uniqueDays = countUniqueDays(messages);
    return ((uniqueDays / 365) * 100).round();
  }

  /// Get word count for most used word
  static int getMostUsedWordCount(List<MessageData> messages, String word) {
    int count = 0;
    
    for (var message in messages) {
      if (message.isUser) {
        final words = message.content
            .toLowerCase()
            .replaceAll(RegExp(r'[^\w\s]'), '')
            .split(RegExp(r'\s+'));
        
        count += words.where((w) => w == word.toLowerCase()).length;
      }
    }
    
    return count;
  }
}

