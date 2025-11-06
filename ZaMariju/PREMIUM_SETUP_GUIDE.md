# Premium Features Setup Guide

## Overview
Premium features use OpenAI API to analyze user messages and generate personality insights, roasts, zodiac predictions, etc.

## Complete Flow

### 1. User Gets Data via ChatFetcher

```
User → ChatFetcher → Login to ChatGPT → Fetch 100 conversations →
Export for GPT Wrapped → Data copied to clipboard
```

### 2. User Imports to ZaMariju

```
User → ZaMariju → Import Chat Data → Read from clipboard →
Parse conversations → Show Free Screens
```

### 3. User Subscribes to Premium

```
User → Choose Plan → Subscribe ($2.99 one-time) →
Show "Analyzing with AI..." loading screen
```

### 4. AI Analysis (Backend)

```
ZaMariju → Send user messages to OpenAI API →
Get personality insights →
Show Premium Screens
```

## Setup Instructions

### Step 1: Get OpenAI API Key

1. Go to https://platform.openai.com/api-keys
2. Sign up or log in
3. Click "Create new secret key"
4. Copy the key (starts with `sk-...`)
5. Save it securely!

### Step 2: Add API Key to Code

Open `ZaMariju/lib/services/ai_analyzer.dart` and replace:

```dart
static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';
```

With your actual key:

```dart
static const String _apiKey = 'sk-proj-...'; // Your real key
```

**⚠️ IMPORTANT SECURITY:**
- Never commit your API key to Git
- Add to `.gitignore`: `**/ai_analyzer.dart` if needed
- For production, use environment variables or secure storage

### Step 3: Install Dependencies

```bash
cd ZaMariju
flutter pub get
```

This installs:
- `http: ^1.2.0` - For API calls
- `google_fonts: ^6.1.0` - For iOS fonts

### Step 4: Test Premium Flow

```dart
// In your subscription screen, after user pays:
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/services/data_processor.dart';

// After user subscribes
void onUserSubscribed() async {
  // Show loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Analyzing with AI...'),
        ],
      ),
    ),
  );

  try {
    // Get conversations from earlier import
    final stats = await DataProcessor.processFromClipboard();
    
    // Parse to get full conversations
    final conversations = // ... your parsed conversations
    
    // Analyze with AI
    final insights = await PremiumProcessor.analyzePremiumInsights(
      conversations,
      (progress) {
        print(progress); // e.g., "Analyzing personality type..."
      },
    );
    
    Navigator.pop(context); // Close loading
    
    // Navigate to premium screens with insights
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PremiumWrappedNavigator(insights: insights),
      ),
    );
    
  } catch (e) {
    Navigator.pop(context); // Close loading
    
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error analyzing data: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

## API Calls & Costs

### Per User Premium Analysis:

| Feature | API Calls | Tokens | Cost |
|---------|-----------|--------|------|
| Type A/B Personality | 1 | ~500 | $0.0015 |
| Red/Green Flags | 1 | ~500 | $0.0015 |
| Love Language | 1 | ~500 | $0.0015 |
| Introvert/Extrovert | 1 | ~500 | $0.0015 |
| MBTI Personality | 1 | ~500 | $0.0015 |
| Zodiac Sign | 1 | ~500 | $0.0015 |
| Most Asked Advice | 1 | ~500 | $0.0015 |
| Roast Me | 1 | ~500 | $0.0015 |
| Past Life Persona | 1 | ~500 | $0.0015 |
| **TOTAL** | **9** | **~4500** | **~$0.0135** |

**Using GPT-4o-mini:**
- Input: $0.150 / 1M tokens
- Output: $0.600 / 1M tokens
- Average cost per user: **$0.01-0.02**

### Profit Calculation:

```
Premium Price: $2.99
API Cost: $0.02
Profit: $2.97 per user (99.3% margin!)
```

## Usage in Premium Screens

### Example: Type A/B Screen

```dart
TypeABPersonalityScreen(
  question: 'Are you Type A or Type B according to ChatGPT?',
  personalityType: insights.personalityType,
  typeEmoji: insights.personalityType == 'TYPE A' ? '⚡' : '🌊',
  typeAPercentage: insights.typeAPercentage,
  typeBPercentage: insights.typeBPercentage,
  explanation: insights.typeExplanation,
  subtitle: 'Knowing yourself is the first step to growth 🌟',
)
```

### Example: Roast Screen

```dart
RoastScreen(
  roastText: insights.roastText,
)
```

### Example: Red/Green Flags

```dart
RedGreenFlagsScreen(
  question: 'What are your red and green flags according to ChatGPT?',
  greenFlagTitle: 'Green Flags 🟢',
  redFlagTitle: 'Red Flags 🔴',
  greenFlags: insights.greenFlags,
  redFlags: insights.redFlags,
  subtitle: 'Self-love also includes recognizing our areas for improvement 💚❤️',
)
```

## Error Handling

### Common Issues:

**1. "Please set your OpenAI API key"**
- Solution: Add your API key in `ai_analyzer.dart`

**2. "OpenAI API error: 401"**
- Solution: Invalid API key, check it's correct

**3. "OpenAI API error: 429"**
- Solution: Rate limit exceeded, add delays or upgrade plan

**4. "Failed to parse JSON from OpenAI response"**
- Solution: OpenAI didn't return valid JSON, retry or adjust prompt

### Add Retry Logic:

```dart
int retries = 0;
while (retries < 3) {
  try {
    final result = await AIAnalyzer.analyzePersonalityType(messages);
    break;
  } catch (e) {
    retries++;
    if (retries >= 3) rethrow;
    await Future.delayed(Duration(seconds: 2));
  }
}
```

## Testing

### Test with Demo Data

```dart
// For development/testing without API costs
final demoInsights = PremiumProcessor.createDemoInsights();

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (ctx) => PremiumWrappedNavigator(insights: demoInsights),
  ),
);
```

### Test with Real API

1. Use a small sample (5-10 conversations)
2. Check API usage at https://platform.openai.com/usage
3. Verify costs are as expected
4. Test all 9 premium screens

## Production Checklist

- [ ] API key stored securely (not in code)
- [ ] Error handling for all API calls
- [ ] Rate limiting protection
- [ ] Loading states with progress
- [ ] Fallback to demo data if API fails
- [ ] Cost monitoring dashboard
- [ ] User feedback for slow AI analysis
- [ ] Timeout handling (30s max)
- [ ] Cache results to avoid re-analysis

## Security Best Practices

### 1. Environment Variables

```dart
// Use flutter_dotenv or similar
static String get apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
```

### 2. Backend Proxy (Recommended)

Instead of calling OpenAI directly from app:

```
App → Your Backend → OpenAI API → Backend → App
```

Benefits:
- Hide API key from app
- Add authentication/rate limiting
- Monitor usage per user
- Prevent abuse

### 3. Rate Limiting

```dart
static DateTime? _lastCallTime;

static Future<void> _enforceRateLimit() async {
  if (_lastCallTime != null) {
    final elapsed = DateTime.now().difference(_lastCallTime!);
    if (elapsed.inMilliseconds < 500) {
      await Future.delayed(Duration(milliseconds: 500 - elapsed.inMilliseconds));
    }
  }
  _lastCallTime = DateTime.now();
}
```

## Scaling Considerations

### For 1,000 premium users:

```
1,000 users × $0.02 = $20 in API costs
1,000 users × $2.99 = $2,990 revenue
Profit: $2,970
```

### For 10,000 premium users:

```
10,000 users × $0.02 = $200 in API costs
10,000 users × $2.99 = $29,900 revenue
Profit: $29,700
```

### Optimization Tips:

1. **Cache results** - Don't re-analyze same data
2. **Batch requests** - Use GPT-4o-mini batch API (50% off)
3. **Reduce tokens** - Send only essential messages
4. **Use cheaper model** - GPT-3.5-turbo if quality is OK

## Support

If you encounter issues:
- Check OpenAI API status: https://status.openai.com
- Review API docs: https://platform.openai.com/docs
- Monitor usage: https://platform.openai.com/usage
- Check rate limits: https://platform.openai.com/account/rate-limits















