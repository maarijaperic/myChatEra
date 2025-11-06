import 'dart:math';
import '../models/chat_data.dart';

/// Calculates basic stats from conversations without AI
class StatsCalculator {
  /// Calculate all stats from conversation list
  static ChatStats calculateStats(List<ConversationData> conversations) {
    if (conversations.isEmpty) {
      return ChatStats.empty();
    }

    // Sort by date
    final sorted = List<ConversationData>.from(conversations)
      ..sort((a, b) => a.createTime.compareTo(b.createTime));

    final firstDate = sorted.first.createTime;
    final lastDate = sorted.last.updateTime;
    final totalDays = lastDate.difference(firstDate).inDays + 1;

    // Calculate total time (rough estimate based on conversation count and activity)
    final totalConversations = conversations.length;
    // Average 5 minutes per conversation
    final estimatedMinutes = totalConversations * 5;
    final totalHours = estimatedMinutes ~/ 60;
    final totalMinutes = estimatedMinutes % 60;

    // Calculate messages per day
    final messagesPerDay = totalDays > 0 ? (totalConversations / totalDays).round() : 0;

    // Calculate longest streak
    final longestStreak = _calculateLongestStreak(conversations);

    // Calculate peak time
    final peakHourData = _calculatePeakHour(conversations);
    final peakHour = peakHourData['hour'] as int;
    final peakTime = peakHourData['time'] as String;

    // Pick a random question from conversation titles
    final randomQuestion = _pickRandomQuestion(conversations);

    // Find main topic from titles
    final mainTopic = _findMainTopic(conversations);

    return ChatStats(
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      messagesPerDay: max(1, messagesPerDay),
      longestStreak: max(1, longestStreak),
      peakTime: peakTime,
      peakHour: peakHour,
      randomQuestion: randomQuestion,
      mainTopic: mainTopic,
      firstChatDate: firstDate,
      lastChatDate: lastDate,
      totalConversations: totalConversations,
      totalMessages: totalConversations * 8, // Rough estimate: ~8 messages per conversation
      mostUsedWordCount: null, // Can't calculate without messages
      totalDays: totalDays,
      yearPercentage: ((totalDays / 365) * 100).round(),
    );
  }

  /// Calculate longest streak of consecutive days with conversations
  static int _calculateLongestStreak(List<ConversationData> conversations) {
    if (conversations.isEmpty) return 0;

    // Group conversations by date
    final dateSet = <String>{};
    for (final conv in conversations) {
      final dateStr = '${conv.createTime.year}-${conv.createTime.month}-${conv.createTime.day}';
      dateSet.add(dateStr);
    }

    final dates = dateSet.map((d) {
      final parts = d.split('-');
      return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    }).toList()
      ..sort();

    if (dates.isEmpty) return 0;

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
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

  /// Calculate peak chatting hour
  static Map<String, dynamic> _calculatePeakHour(List<ConversationData> conversations) {
    final hourCounts = <int, int>{};

    for (final conv in conversations) {
      final hour = conv.createTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    if (hourCounts.isEmpty) {
      return {'hour': 23, 'time': 'night'};
    }

    // Find hour with most conversations
    int peakHour = 23;
    int maxCount = 0;
    hourCounts.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        peakHour = hour;
      }
    });

    // Determine time of day
    String peakTime;
    if (peakHour >= 5 && peakHour < 12) {
      peakTime = 'morning';
    } else if (peakHour >= 12 && peakHour < 17) {
      peakTime = 'afternoon';
    } else if (peakHour >= 17 && peakHour < 22) {
      peakTime = 'evening';
    } else {
      peakTime = 'night';
    }

    return {'hour': peakHour, 'time': peakTime};
  }

  /// Pick a random interesting question from conversation titles
  static String? _pickRandomQuestion(List<ConversationData> conversations) {
    // Filter for titles that look like questions or interesting topics
    final questions = conversations
        .where((c) => c.title.contains('?') || 
                     c.title.toLowerCase().contains('how') ||
                     c.title.toLowerCase().contains('why') ||
                     c.title.toLowerCase().contains('what') ||
                     c.title.toLowerCase().contains('can'))
        .map((c) => c.title)
        .toList();

    if (questions.isEmpty) {
      // Fallback to any random title
      final allTitles = conversations.map((c) => c.title).where((t) => t.length > 10).toList();
      if (allTitles.isEmpty) return null;
      return allTitles[Random().nextInt(allTitles.length)];
    }

    return questions[Random().nextInt(questions.length)];
  }

  /// Find main topic by analyzing conversation titles
  static String? _findMainTopic(List<ConversationData> conversations) {
    // Count word frequency in titles
    final wordCounts = <String, int>{};
    final commonWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'be', 'been',
      'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
      'should', 'may', 'might', 'can', 'how', 'what', 'why', 'when', 'where',
      'me', 'you', 'i', 'my', 'help', 'please', 'thanks', 'need'
    };

    for (final conv in conversations) {
      final words = conv.title
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(' ')
          .where((w) => w.length > 3 && !commonWords.contains(w));

      for (final word in words) {
        wordCounts[word] = (wordCounts[word] ?? 0) + 1;
      }
    }

    if (wordCounts.isEmpty) return 'General Chat';

    // Find most common meaningful word
    String topWord = 'Chat';
    int maxCount = 0;
    wordCounts.forEach((word, count) {
      if (count > maxCount) {
        maxCount = count;
        topWord = word;
      }
    });

    // Capitalize first letter
    return topWord[0].toUpperCase() + topWord.substring(1);
  }
}


