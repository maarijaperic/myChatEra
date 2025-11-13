# Implementation Guide: Free Screens Data Processing

## Overview
This guide explains how to implement the calculation system for free screens without using any AI APIs.

## How It Works

### 1. User Exports ChatGPT Data
Users need to export their ChatGPT conversations:
1. Go to ChatGPT Settings
2. Navigate to "Data Controls"  
3. Click "Export Data"
4. Download the `conversations.json` file

### 2. Upload & Parse
The app parses the JSON file using `ChatParser`:
```dart
import 'package:gpt_wrapped2/services/data_processor.dart';

// In your import screen or button handler:
final stats = await DataProcessor.processExportFile();

if (stats != null) {
  // Navigate to screens with stats
  Navigator.push(...);
} else {
  // Show error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to load data')),
  );
}
```

### 3. Calculate Metrics
The `ChatAnalyzer` calculates all metrics:

#### Daily Dose (Messages per Day)
```dart
// Total messages / unique days
messagesPerDay = totalMessages / uniqueDays
```

#### Your Chat Era (Total Time)
```dart
// Duration from first to last message
totalHours = (lastMessage - firstMessage).inHours
totalMinutes = (lastMessage - firstMessage).inMinutes % 60
```

#### Where It All Began (First Message)
```dart
// First user message in chronological order
firstMessage = messages.where((m) => m.isUser).first.content
```

#### Your Signature Word (Most Used Word)
```dart
// Count all words, exclude common stop words
// Return word with highest count
mostUsedWord = wordCounts.maxBy((word, count) => count)
```

#### Chat Days Tracker
```dart
// Count unique days
totalDays = uniqueDays.length
yearPercentage = (totalDays / 365 * 100).round()
```

#### Longest Chat Streak
```dart
// Find consecutive days pattern
for each day in uniqueDays:
  if day - previousDay == 1:
    currentStreak++
  else:
    currentStreak = 1
  longestStreak = max(longestStreak, currentStreak)
```

#### Speed of Response
```dart
// Average time between user message and AI response
responseTimes = []
for each (userMsg, assistantMsg) pair:
  responseTimes.add(assistantMsg.time - userMsg.time)

averageResponseTime = sum(responseTimes) / responseTimes.length
```

#### GPT O'Clock (Peak Time)
```dart
// Count messages by hour
hourCounts = {0: 5, 1: 2, ..., 23: 10}
peakHour = hourCounts.maxBy((hour, count) => count)

// Convert to time of day
if peakHour >= 5 && peakHour < 12: 'morning'
else if peakHour >= 12 && peakHour < 17: 'afternoon'
else if peakHour >= 17 && peakHour < 21: 'evening'
else: 'night'
```

## File Structure

```
lib/
├── models/
│   └── chat_data.dart           # Data models
├── services/
│   ├── chat_parser.dart         # Parses JSON file
│   ├── chat_analyzer.dart       # Calculates metrics
│   └── data_processor.dart      # Orchestrates everything
└── screens/
    └── screen_import_data.dart  # File upload UI
```

## Installation Steps

### 1. Install Dependencies
Run this command in your terminal:
```bash
cd ZaMariju
flutter pub get
```

This will install:
- `file_picker: ^8.0.0+1` - For file upload
- `google_fonts: ^6.1.0` - For iOS-like fonts

### 2. Update Import Data Screen

```dart
import 'package:gpt_wrapped2/services/data_processor.dart';

class ImportDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Process the file
            final stats = await DataProcessor.processExportFile();
            
            if (stats != null) {
              // Navigate to analyzing loading screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalyzingLoadingScreen(
                    onComplete: () {
                      // Navigate to free wrapped screens with stats
                      Navigator.push(...);
                    },
                  ),
                ),
              );
            } else {
              // Show error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load data')),
              );
            }
          },
          child: Text('Upload ChatGPT Data'),
        ),
      ),
    );
  }
}
```

### 3. Pass Stats to Screens

Update your main.dart to pass real stats instead of demo data:

```dart
class _FreeWrappedNavigator extends StatelessWidget {
  final ChatStats stats;  // Add this
  
  @override
  Widget build(BuildContext context) {
    return CardNavigator(
      screens: [
        // Use real stats
        DailyDoseScreen(
          messagesPerDay: stats.messagesPerDay,
        ),
        ChatEraScreen(
          totalHours: stats.totalHours,
          totalMinutes: stats.totalMinutes,
        ),
        MostUsedWordScreen(
          mostUsedWord: stats.mainTopic ?? 'question',
          wordCount: 100, // Calculate separately if needed
        ),
        ChatDaysTrackerScreen(
          totalDays: ChatAnalyzer.countUniqueDays(messages),
          yearPercentage: ChatAnalyzer.calculateYearPercentage(messages),
        ),
        // ... etc
      ],
    );
  }
}
```

## Testing with Demo Data

For testing, you can use demo data:

```dart
final demoStats = DataProcessor.createDemoStats();
// Pass demoStats to screens
```

## Cost Analysis

### Free Screens: $0 💰
- All calculations done locally
- No API calls
- Pure data parsing and math

### Premium Screens: OpenAI API Costs
- Personality analysis
- Red/Green flags
- Roasting
- Zodiac prediction
- etc.

**Estimated cost per user for premium:**
- ~5-10 API calls at $0.002 per call
- Total: ~$0.01-$0.02 per user

## ChatGPT Export Format

The conversations.json file looks like this:

```json
[
  {
    "id": "conversation-id",
    "title": "Conversation Title",
    "create_time": 1234567890.123,
    "update_time": 1234567890.456,
    "mapping": {
      "message-id-1": {
        "id": "message-id-1",
        "message": {
          "author": {"role": "user"},
          "content": {"parts": ["User message text"]},
          "create_time": 1234567890.123
        }
      },
      "message-id-2": {
        "id": "message-id-2",
        "message": {
          "author": {"role": "assistant"},
          "content": {"parts": ["Assistant response"]},
          "create_time": 1234567890.789
        }
      }
    }
  }
]
```

## Next Steps

1. Run `flutter pub get` to install dependencies
2. Test file upload with a sample conversations.json
3. Verify calculations are correct
4. Add error handling for edge cases
5. Implement caching (optional) to save calculated stats

## Support

If you encounter issues:
- Check the file format matches ChatGPT export
- Verify all messages have timestamps
- Test with a small file first
- Check console logs for parsing errors
















