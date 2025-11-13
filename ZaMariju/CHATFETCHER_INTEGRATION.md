# ChatFetcher Integration Guide

## Overview
This guide explains how ZaMariju integrates with ChatFetcher for authentication and data fetching.

## Architecture

### Two-App System:

**ChatFetcher** (Login & Data Fetching)
- Opens ChatGPT in WebView
- User logs in with their ChatGPT account
- Fetches conversations via JavaScript injection
- Exports data to clipboard

**ZaMariju** (Analysis & Wrapped Screens)
- Reads data from clipboard
- Parses and analyzes conversations
- Displays wrapped screens with stats

## User Flow

### Step 1: Get Data from ChatFetcher

1. User opens **ChatFetcher app**
2. WebView loads chatgpt.com
3. User logs in (Google/Apple/Email)
4. User clicks **"Fetch up to 100 convos"** button
5. ChatFetcher fetches conversations via API
6. User clicks **"Export for GPT Wrapped"** button
7. Data is **copied to clipboard**
8. User sees success message

### Step 2: Import to ZaMariju

1. User opens **ZaMariju app**
2. Taps **"Import Chat Data"** button
3. App reads JSON from clipboard
4. Shows "Analyzing Your Chats" loading screen
5. Displays wrapped screens with real stats

## Implementation

### In Your Import Screen

```dart
import 'package:gpt_wrapped2/services/data_processor.dart';
import 'package:flutter/material.dart';

class ImportDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Import Your ChatGPT Data'),
            SizedBox(height: 20),
            Text('1. Open ChatFetcher app'),
            Text('2. Login to ChatGPT'),
            Text('3. Click "Export for GPT Wrapped"'),
            Text('4. Come back and click Import below'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => Center(child: CircularProgressIndicator()),
                );

                // Read from clipboard
                final stats = await DataProcessor.processFromClipboard();
                
                Navigator.pop(context); // Close loading

                if (stats != null) {
                  // Navigate to analyzing screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AnalyzingLoadingScreen(
                        onComplete: () {
                          // Navigate to wrapped screens with stats
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => FreeWrappedNavigator(stats: stats),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // Show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No data found in clipboard.\nPlease use ChatFetcher to export data first.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Import from Clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Data Format from ChatFetcher

ChatFetcher exports conversations in this format:
```json
[
  {
    "id": "conv-id",
    "title": "Conversation title",
    "create_time": 1234567890.123,
    "update_time": 1234567890.456
  },
  ...
]
```

**Note:** ChatFetcher exports the conversation LIST, not full message details. To get full messages, you need to:

1. **Option A:** Modify ChatFetcher to fetch full conversation details for each conversation
2. **Option B:** Use the conversation metadata for basic stats (dates, counts)
3. **Option C:** Have users export full data from ChatGPT settings

## What Gets Calculated (No API Costs!)

### With Basic Conversation List:
✅ Total conversations count
✅ Date range (first to last chat)
✅ Total time span
✅ Conversations per day
✅ Peak time analysis (from timestamps)
✅ Chat streak (consecutive days)

### Requires Full Message Data:
❌ First message content
❌ Most used word
❌ Average response time
❌ Messages per day

## Upgrading ChatFetcher for Full Data

To get full message data, modify ChatFetcher's `_exportForGPTWrapped()`:

```dart
Future<void> _exportForGPTWrapped() async {
  if (_conversations.isEmpty) return;
  
  // Fetch full conversation details for each
  final fullConversations = <Map<String, dynamic>>[];
  
  for (var conv in _conversations) {
    final id = conv['id'];
    // Fetch full conversation using the JavaScript method
    final fullConv = await _fetchSingleConversation(id);
    fullConversations.add(fullConv);
  }
  
  final jsonStr = jsonEncode(fullConversations);
  await Clipboard.setData(ClipboardData(text: jsonStr));
  
  // Show success
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Exported ${fullConversations.length} full conversations!'),
      backgroundColor: Colors.green,
    ),
  );
}
```

## Testing

### Test with Demo Data

```dart
// For testing without ChatFetcher
final demoStats = DataProcessor.createDemoStats();

// Use demo stats in your screens
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (ctx) => FreeWrappedNavigator(stats: demoStats),
  ),
);
```

### Test with Real Data

1. Use ChatFetcher to export data
2. Check clipboard contains JSON
3. Import in ZaMariju
4. Verify stats are calculated correctly

## Cost Analysis

### Free Screens (ChatFetcher + ZaMariju): $0 💰
- ChatFetcher uses existing ChatGPT session (no extra API calls)
- ZaMariju does local data analysis only
- **Completely free!**

### Premium Screens: ~$0.01-0.02 per user
- Requires OpenAI API calls for:
  - Personality analysis
  - Red/green flags
  - Zodiac prediction
  - Roasting
  - etc.

## Troubleshooting

### "No data found in clipboard"
- Make sure ChatFetcher successfully exported data
- Check that you clicked "Export for GPT Wrapped" button
- Verify clipboard permission is granted

### "Failed to parse data"
- Data format from ChatFetcher might have changed
- Check console logs for parsing errors
- Verify JSON is valid

### Missing metrics
- Check if you have full conversation data or just metadata
- Some metrics require full message content
- Consider upgrading ChatFetcher export

## Future Enhancements

1. **Direct App Communication**: Use platform channels instead of clipboard
2. **Background Sync**: Auto-fetch updates periodically
3. **Full Message Export**: Upgrade ChatFetcher to export complete conversations
4. **Caching**: Save analyzed stats locally
5. **Incremental Updates**: Only fetch new conversations





















