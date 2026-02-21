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

  /// Get activity distribution by time periods (8 AM, 12 PM, 6 PM, 2 AM)
  /// Returns map with time period labels and message counts
  static Map<String, int> getActivityByTimePeriods(List<MessageData> messages) {
    if (messages.isEmpty) {
      return {
        '8 AM': 0,
        '12 PM': 0,
        '6 PM': 0,
        '2 AM': 0,
      };
    }

    final periodCounts = <String, int>{
      '8 AM': 0,
      '12 PM': 0,
      '6 PM': 0,
      '2 AM': 0,
    };

    for (var message in messages) {
      final hour = message.timestamp.hour;
      
      // 8 AM period: 6-10 AM
      if (hour >= 6 && hour < 10) {
        periodCounts['8 AM'] = (periodCounts['8 AM'] ?? 0) + 1;
      }
      // 12 PM period: 10 AM - 2 PM
      else if (hour >= 10 && hour < 14) {
        periodCounts['12 PM'] = (periodCounts['12 PM'] ?? 0) + 1;
      }
      // 6 PM period: 4 PM - 8 PM
      else if (hour >= 16 && hour < 20) {
        periodCounts['6 PM'] = (periodCounts['6 PM'] ?? 0) + 1;
      }
      // 2 AM period: 10 PM - 6 AM (night/early morning)
      else {
        periodCounts['2 AM'] = (periodCounts['2 AM'] ?? 0) + 1;
      }
    }

    return periodCounts;
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
    
    // Extended list of common words to ignore
    final stopWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'be',
      'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will',
      'would', 'could', 'should', 'may', 'might', 'must', 'can', 'i', 'you',
      'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us', 'them',
      'my', 'your', 'his', 'hers', 'its', 'our', 'their', 'this', 'that',
      'these', 'those', 'what', 'which', 'who', 'when', 'where', 'why', 'how',
      'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some',
      'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too',
      'very', 'just', 'now', 'then', 'here', 'there', 'about', 'into', 'through',
      'during', 'before', 'after', 'above', 'below', 'up', 'down', 'out', 'off',
      'over', 'under', 'again', 'further', 'once', 'also', 'back', 'well',
      'get', 'got', 'go', 'went', 'come', 'came', 'see', 'saw', 'know', 'knew',
      'think', 'thought', 'take', 'took', 'give', 'gave', 'make', 'made',
      'say', 'said', 'tell', 'told', 'ask', 'asked', 'want', 'wanted', 'need',
      'needed', 'try', 'tried', 'use', 'used', 'work', 'worked', 'help', 'helped',
      'like', 'liked', 'look', 'looked', 'find', 'found', 'feel', 'felt',
      'chat', 'gpt', 'chatgpt', 'ai', 'message', 'messages', 'conversation',
      'conversations', 'thanks', 'thank', 'please', 'sorry', 'yeah', 'yes',
    };

    // Only analyze user messages
    for (var message in messages) {
      if (message.isUser && message.content.trim().isNotEmpty) {
        // Split into words and count
        final cleaned = message.content
            .toLowerCase()
            .replaceAll(RegExp(r'[^\w\s]'), ' '); // Remove punctuation
        
        final words = cleaned
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty && w.length > 2)
            .toList();
        
        for (var word in words) {
          // Only count meaningful words (not a stop word, not a number)
          if (!stopWords.contains(word) && 
              !RegExp(r'^\d+$').hasMatch(word)) {
            wordCounts[word] = (wordCounts[word] ?? 0) + 1;
          }
        }
      }
    }

    if (wordCounts.isEmpty) {
      print('🔵 ANALYZER_DEBUG: No words found in messages');
      return null;
    }

    print('🔵 ANALYZER_DEBUG: Found ${wordCounts.length} unique words');
    // Log top 10 words for debugging
    final sortedWords = wordCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    print('🔵 ANALYZER_DEBUG: Top 10 words:');
    for (int i = 0; i < sortedWords.length && i < 10; i++) {
      print('🔵 ANALYZER_DEBUG:   ${sortedWords[i].key}: ${sortedWords[i].value}');
    }

    // Find most common word - return the word with highest count (no minimum threshold)
    String? mostUsedWord;
    int maxCount = 0;
    
    wordCounts.forEach((word, count) {
      // Skip the word "null" if it appears
      if (word.toLowerCase() == 'null') {
        print('🔵 ANALYZER_DEBUG: Skipping word "null"');
        return;
      }
      if (count > maxCount) {
        maxCount = count;
        mostUsedWord = word;
      }
    });

    // Capitalize first letter for better display
    if (mostUsedWord != null && mostUsedWord!.isNotEmpty && mostUsedWord!.toLowerCase() != 'null') {
      mostUsedWord = mostUsedWord![0].toUpperCase() + mostUsedWord!.substring(1);
    } else if (mostUsedWord != null && mostUsedWord!.toLowerCase() == 'null') {
      print('🔵 ANALYZER_DEBUG: Most used word is "null", returning null instead');
      mostUsedWord = null;
    }

    print('🔵 ANALYZER_DEBUG: Most used word = $mostUsedWord (count: $maxCount)');
    return mostUsedWord;
  }

  /// Calculate average response time (for "Speed of Response" screen)
  static double calculateAverageResponseTime(List<MessageData> messages) {
    if (messages.length < 2) return 0.0;

    final responseTimes = <Duration>[];
    
    // Sort messages by timestamp to ensure correct order
    final sortedMessages = List<MessageData>.from(messages)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    for (int i = 0; i < sortedMessages.length - 1; i++) {
      // If current is user and next is assistant, calculate response time
      if (sortedMessages[i].isUser && sortedMessages[i + 1].isAssistant) {
        final responseTime = sortedMessages[i + 1].timestamp.difference(sortedMessages[i].timestamp);
        
        // Only count reasonable response times (between 1 second and 1 hour)
        // This filters out cases where user sent multiple messages before getting a response
        if (responseTime.inSeconds >= 1 && responseTime.inHours < 1) {
          responseTimes.add(responseTime);
        }
      }
    }

    if (responseTimes.isEmpty) return 0.0;

    // Calculate average in seconds
    final totalSeconds = responseTimes.fold<int>(0, (sum, duration) => sum + duration.inSeconds);
    final average = totalSeconds / responseTimes.length;
    
    // Round to 1 decimal place
    return (average * 10).round() / 10;
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
  /// Always uses 365 days as the base (full year), regardless of actual date range
  static int calculateYearPercentage(List<MessageData> messages) {
    if (messages.isEmpty) return 0;
    
    final uniqueDays = countUniqueDays(messages);
    if (uniqueDays == 0) return 0;
    
    // Always use 365 days as the base for year percentage calculation
    // This ensures consistent percentage regardless of when the user started using ChatGPT
    return ((uniqueDays / 365) * 100).round().clamp(0, 100);
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

  /// Get top 5 most used words (minimum 5 letters each). Only real words (letters only, no metadata keys).
  static List<MapEntry<String, int>> getTop5MostUsedWords(List<MessageData> messages) {
    final wordCounts = <String, int>{};
    
    // Only count words that look like real words: letters only (optional hyphen), no underscores
    final realWordPattern = RegExp(r'^[a-zA-Z\-]+$');

    // Extended list of common words to ignore
    final stopWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'be',
      'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will',
      'would', 'could', 'should', 'may', 'might', 'must', 'can', 'i', 'you',
      'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'us', 'them',
      'my', 'your', 'his', 'hers', 'its', 'our', 'their', 'this', 'that',
      'these', 'those', 'what', 'which', 'who', 'when', 'where', 'why', 'how',
      'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some',
      'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too',
      'very', 'just', 'now', 'then', 'here', 'there', 'about', 'into', 'through',
      'during', 'before', 'after', 'above', 'below', 'up', 'down', 'out', 'off',
      'over', 'under', 'again', 'further', 'once', 'also', 'back', 'well',
      'get', 'got', 'go', 'went', 'come', 'came', 'see', 'saw', 'know', 'knew',
      'think', 'thought', 'take', 'took', 'give', 'gave', 'make', 'made',
      'say', 'said', 'tell', 'told', 'ask', 'asked', 'want', 'wanted', 'need',
      'needed', 'try', 'tried', 'use', 'used', 'work', 'worked', 'help', 'helped',
      'like', 'liked', 'look', 'looked', 'find', 'found', 'feel', 'felt',
      'chat', 'gpt', 'chatgpt', 'ai', 'message', 'messages', 'conversation',
      'conversations', 'thanks', 'thank', 'please', 'sorry', 'yeah', 'yes',
    };

    // Blocklist: metadata, JSON keys, technical/UI words, and AI model names (not real chat vocabulary)
    final blocklist = {
      'watermarked_asset_pointer', 'image_asset_pointer', 'content_type',
      'asset_pointer', 'pointer', 'content', 'parts', 'text', 'author', 'role',
      'height', 'width', 'length', 'size', 'color', 'padding', 'margin', 'border',
      'image', 'images', 'button', 'screen', 'widget', 'value', 'values', 'type',
      'types', 'data', 'string', 'number', 'object', 'array', 'index', 'pixel',
      'pixels', 'style', 'font', 'layout', 'right', 'left', 'thing', 'things',
      'something', 'nothing', 'really', 'actually', 'probably', 'maybe', 'every',
      'first', 'second', 'third', 'fourth', 'fifth', 'single', 'double', 'table',
      'column', 'row', 'title', 'label', 'input', 'click', 'touch', 'scroll',
      'fovea', 'metadata', 'dalle', 'dall', 'gpt4', 'gpt3', 'openai', 'claude',
      'model', 'models', 'prompt', 'prompts', 'response', 'responses', 'token',
      'tokens', 'api', 'json', 'html', 'css', 'javascript', 'python', 'code',
    };

    // Only analyze user messages
    for (var message in messages) {
      if (message.isUser && message.content.trim().isNotEmpty) {
        // Split into words and count
        final cleaned = message.content
            .toLowerCase()
            .replaceAll(RegExp(r'[^\w\s]'), ' '); // Remove punctuation
        
        final words = cleaned
            .split(RegExp(r'\s+'))
            .where((w) => w.isNotEmpty && w.length >= 5) // Minimum 5 letters
            .toList();
        
        for (var word in words) {
          // Only count real words: no underscores, no numbers, not stop word, not metadata
          if (!stopWords.contains(word) &&
              !RegExp(r'^\d+$').hasMatch(word) &&
              word.length >= 5 &&
              realWordPattern.hasMatch(word) &&
              !word.contains('_') &&
              !blocklist.contains(word)) {
            wordCounts[word] = (wordCounts[word] ?? 0) + 1;
          }
        }
      }
    }

    if (wordCounts.isEmpty) {
      return [];
    }

    // Sort by count descending and take top 5
    final sortedWords = wordCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Capitalize first letter and return top 5
    return sortedWords.take(5).map((entry) {
      final word = entry.key;
      final capitalizedWord = word.isNotEmpty 
          ? word[0].toUpperCase() + word.substring(1)
          : word;
      return MapEntry(capitalizedWord, entry.value);
    }).toList();
  }
}

