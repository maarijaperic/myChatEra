import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gpt_wrapped2/models/chat_data.dart';

/// AI-powered analysis using OpenAI API for premium features
/// Requires API key and costs ~$0.01-0.02 per user
class AIAnalyzer {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  
  /// Your OpenAI API key - Replace with your actual key
  /// Get it from: https://platform.openai.com/api-keys
  static const String _apiKey = 'YOUR_OPENAI_API_KEY_HERE';
  
  /// Analyze personality type (Type A vs Type B)
  static Future<Map<String, dynamic>> analyzePersonalityType(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and determine if the user is Type A or Type B personality.

User messages:
${messagesSample.join('\n')}

Based on these messages, provide:
1. Personality type: "TYPE A" or "TYPE B"
2. Type A percentage (0-100)
3. Type B percentage (0-100)
4. A fun, casual explanation (2-3 sentences, use "you" and be witty)

Respond ONLY with valid JSON in this exact format:
{
  "personalityType": "TYPE A",
  "typeAPercentage": 70,
  "typeBPercentage": 30,
  "explanation": "Based on your conversations, GPT detected strong Type A traits. You're ambitious, organized, and impatient—probably asking follow-up questions before the first answer even finishes. You multitask like a pro, demand efficiency, and low-key stress about everything. But hey, at least you get stuff done. 💪"
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Analyze red and green flags
  static Future<Map<String, dynamic>> analyzeRedGreenFlags(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and identify the user's red and green flags.

User messages:
${messagesSample.join('\n')}

Provide:
1. 5 green flags (positive traits based on how they interact)
2. 5 red flags (areas for improvement, be playful not harsh)

Respond ONLY with valid JSON in this exact format:
{
  "greenFlags": [
    "You always apologize when you make a mistake",
    "You are very creative with your prompts",
    "You ask very intelligent questions",
    "You have a good sense of humor",
    "You are patient with long answers"
  ],
  "redFlags": [
    "Sometimes you don't read the full answers",
    "You ask for the same thing several times in a row",
    "You don't specify what you want clearly",
    "You get frustrated when you don't understand something",
    "Sometimes you are very impatient"
  ]
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Guess zodiac sign
  static Future<Map<String, dynamic>> guessZodiacSign(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and guess the user's zodiac sign based on their conversation style and topics.

User messages:
${messagesSample.join('\n')}

Provide:
1. Zodiac sign name (e.g., "Scorpio")
2. Zodiac sign with emoji (e.g., "Scorpio ♏")
3. Zodiac emoji only (e.g., "🦂")
4. Fun explanation (2-3 sentences, use "you" and be witty)

Respond ONLY with valid JSON in this exact format:
{
  "zodiacName": "Scorpio",
  "zodiacSign": "Scorpio ♏",
  "zodiacEmoji": "🦂",
  "explanation": "Based on your chats, you're giving major Scorpio energy 🦂✨ Intense conversations? Check. Deep questions at 3 AM? Check. Reading between every single line? That's so you. GPT says you're the friend who turns small talk into therapy sessions. Mysterious vibes only. 💅"
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Analyze introvert vs extrovert
  static Future<Map<String, dynamic>> analyzeIntrovertExtrovert(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and determine if the user is an introvert, extrovert, or ambivert.

User messages:
${messagesSample.join('\n')}

Provide:
1. Personality type: "INTROVERT", "EXTROVERT", or "AMBIVERT"
2. Introvert percentage (0-100)
3. Extrovert percentage (0-100)
4. Explanation (2-3 sentences)

Respond ONLY with valid JSON in this exact format:
{
  "personalityType": "AMBIVERT",
  "introvertPercentage": 55,
  "extrovertPercentage": 45,
  "explanation": "According to your conversations, ChatGPT detected that you have a balanced personality. You are an ambivert: you enjoy both moments of solitary reflection and social interactions. You have the ability to adapt to different situations, being introspective when you need to process information and sociable when you want to share ideas."
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Get most asked advice category
  static Future<Map<String, dynamic>> analyzeMostAskedAdvice(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 40);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and identify what advice the user asks for most.

User messages:
${messagesSample.join('\n')}

Provide:
1. Most asked advice (short phrase)
2. Advice category (one word: RELATIONSHIPS, CAREER, HEALTH, TECH, PERSONAL, etc.)
3. Advice emoji (relevant emoji)
4. Explanation (2-3 sentences)

Respond ONLY with valid JSON in this exact format:
{
  "mostAskedAdvice": "How to improve my personal relationships",
  "adviceCategory": "RELATIONSHIPS",
  "adviceEmoji": "💕",
  "explanation": "According to the analysis of your conversations, you have sought advice about personal relationships more than any other topic. This shows that you value human connections and always seek to improve the way you relate to others. Your curiosity to better understand social dynamics is admirable."
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Determine love language
  static Future<Map<String, dynamic>> analyzeLoveLanguage(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and determine the user's love language.

User messages:
${messagesSample.join('\n')}

The 5 love languages are:
- Words of Affirmation
- Acts of Service
- Receiving Gifts
- Quality Time
- Physical Touch

Provide:
1. Love language name
2. Love language emoji
3. Fun explanation (2-3 sentences, witty and casual)

Respond ONLY with valid JSON in this exact format:
{
  "loveLanguage": "Words of Affirmation",
  "languageEmoji": "💬",
  "explanation": "Based on your chats, GPT noticed you light up when validated. You seek reassurance, ask follow-up questions to make sure you're understood, and appreciate detailed explanations. You love when GPT acknowledges your ideas and reflects them back. Basically, you're the type who needs to hear 'You're doing great!' even from an AI. And honestly? You are. 💕"
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Determine MBTI personality type
  static Future<Map<String, dynamic>> analyzeMBTI(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and determine the user's MBTI personality type.

User messages:
${messagesSample.join('\n')}

Provide:
1. MBTI type (e.g., "ENFP", "INTJ", etc.)
2. MBTI emoji
3. Personality name (e.g., "The Enthusiast")
4. Explanation (2-3 sentences)

Respond ONLY with valid JSON in this exact format:
{
  "mbtiType": "ENFP",
  "mbtiEmoji": "🎭",
  "personalityName": "The Enthusiast",
  "explanation": "According to the analysis of your conversations, ChatGPT detected that you are an ENFP (Extroverted, Intuitive, Feeling, Perceiving). You are an enthusiastic, creative and sociable person who is motivated by possibilities. You have a great ability to connect with others and always seek new experiences and challenges. Your positive energy and your ability to inspire others are your greatest strengths."
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Determine past life persona
  static Future<Map<String, dynamic>> analyzePastLifePersona(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 30);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and determine who the user was in a past life based on their interests and conversation style.

User messages:
${messagesSample.join('\n')}

Provide:
1. Persona title (e.g., "Renaissance Philosopher-Artist")
2. Persona emoji
3. Era (e.g., "15TH CENTURY FLORENCE")
4. Description (3-4 sentences, creative and fun)

Respond ONLY with valid JSON in this exact format:
{
  "personaTitle": "Renaissance Philosopher-Artist",
  "personaEmoji": "🎨",
  "era": "15TH CENTURY FLORENCE",
  "description": "You were a Renaissance thinker who questioned everything and created beauty from chaos. Your conversations reveal a mind that blends logic with creativity, always seeking deeper meaning. Like Da Vinci, you jump between disciplines—art, science, philosophy—never satisfied with surface-level answers. You probably had a dramatic scarf and too many unfinished projects."
}
''';

    return await _callOpenAI(prompt);
  }
  
  /// Generate a roast
  static Future<String> generateRoast(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 40);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and write a funny, playful roast about the user's ChatGPT usage habits.

User messages:
${messagesSample.join('\n')}

Write a roast that is:
- Funny and lighthearted (not mean)
- 3-4 sentences
- About their ChatGPT usage patterns
- Uses "you" and emojis
- Playfully calls them out

Respond ONLY with the roast text, no JSON, no extra formatting.
''';

    final result = await _callOpenAI(prompt, expectJson: false);
    return result['text'] ?? 'You ask ChatGPT everything. Like... everything. 💀';
  }
  
  /// Helper: Get sample of user messages
  static List<String> _getSampleMessages(List<MessageData> messages, {int maxCount = 30}) {
    final userMessages = messages
        .where((m) => m.isUser)
        .map((m) => m.content)
        .where((c) => c.trim().isNotEmpty)
        .toList();
    
    // Take evenly distributed sample
    if (userMessages.length <= maxCount) {
      return userMessages;
    }
    
    final step = userMessages.length / maxCount;
    final sample = <String>[];
    for (var i = 0; i < maxCount; i++) {
      final index = (i * step).floor();
      if (index < userMessages.length) {
        sample.add(userMessages[index]);
      }
    }
    
    return sample;
  }
  
  /// Helper: Call OpenAI API
  static Future<Map<String, dynamic>> _callOpenAI(String prompt, {bool expectJson = true}) async {
    if (_apiKey == 'YOUR_OPENAI_API_KEY_HERE') {
      throw Exception('Please set your OpenAI API key in ai_analyzer.dart');
    }
    
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini', // Cheaper and faster than gpt-4
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that analyzes ChatGPT conversation patterns. Always respond in the exact format requested.'
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
      }
      
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      
      if (expectJson) {
        // Parse JSON response
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
        if (jsonMatch != null) {
          return jsonDecode(jsonMatch.group(0)!);
        }
        throw Exception('Failed to parse JSON from OpenAI response');
      } else {
        // Return plain text
        return {'text': content.trim()};
      }
      
    } catch (e) {
      print('Error calling OpenAI API: $e');
      rethrow;
    }
  }
}















