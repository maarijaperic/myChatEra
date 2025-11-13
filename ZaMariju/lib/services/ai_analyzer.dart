import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gpt_wrapped2/models/chat_data.dart';

/// AI-powered analysis using OpenAI API for premium features
/// Uses proxy server to hide API key from client
/// Costs ~$0.01-0.02 per user
class AIAnalyzer {
  // Proxy server URL - change this to your deployed proxy server URL
  // For local development: 'http://localhost:3000'
  // For production: 'https://your-proxy-server.com'
  static const String _proxyBaseUrl = String.fromEnvironment(
    'OPENAI_PROXY_URL',
    defaultValue: 'http://localhost:3000',
  );
  
  static const String _proxyApiPath = '/api/chat';
  
  // Legacy direct API support (not recommended for production)
  static const String _directApiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _compiledApiKey = String.fromEnvironment('OPENAI_API_KEY');
  static bool _useProxy = true; // Default to using proxy

  static String? _overrideApiKey;
  static String? _overrideProxyUrl;

  /// Set proxy server URL (e.g., 'https://your-proxy-server.com')
  static void setProxyUrl(String? proxyUrl) {
    _overrideProxyUrl = proxyUrl;
  }

  /// Enable/disable proxy usage (default: true)
  static void setUseProxy(bool useProxy) {
    _useProxy = useProxy;
  }

  /// Allows tests or advanced setups to inject an API key at runtime.
  /// Only used when proxy is disabled.
  static void setApiKeyOverride(String? apiKey) {
    _overrideApiKey = apiKey;
  }

  static String _getProxyUrl() {
    if (_overrideProxyUrl != null && _overrideProxyUrl!.isNotEmpty) {
      return _overrideProxyUrl!;
    }
    return _proxyBaseUrl;
  }

  static String _resolveApiKey() {
    if (_overrideApiKey != null && _overrideApiKey!.isNotEmpty) {
      return _overrideApiKey!;
    }

    final envKey = Platform.environment['OPENAI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty) {
      return envKey;
    }

    if (_compiledApiKey.isNotEmpty) {
      return _compiledApiKey;
    }

    throw Exception(
      'Missing OpenAI API key. Set OPENAI_API_KEY in your environment or .env file.',
    );
  }
  
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

  /// Generate a movie title that matches the user's chat vibe
  static Future<Map<String, dynamic>> generateMovieTitle(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 40);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and pick a movie that best represents the user's overall vibe, journey, and personality.

User messages:
${messagesSample.join('\n')}

Provide:
1. Movie title (string)
2. Release year (integer between 1950 and 2025)
3. Fun explanation (3-4 sentences, cinematic tone, direct "you" language, references how the chats match the movie's themes)

Respond ONLY with valid JSON in this exact format:
{
  "movieTitle": "The Pursuit of Happyness",
  "releaseYear": 2006,
  "explanation": "Based on your conversations, GPT detected a relentless drive for self-improvement and asking deep questions about life. Like Chris Gardner in the movie, you are constantly searching for answers, optimizing your life, and never giving up on personal growth. Your chats are basically a journey of someone trying to figure it all out - one prompt at a time. Inspiring, honestly."
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

IMPORTANT: The era must be from ancient times up to and including the 20th century (1900-2000). DO NOT use the 21st century (2001 or later) since we are currently living in the 21st century and past lives should be from previous centuries.

User messages:
${messagesSample.join('\n')}

Provide:
1. Persona title (e.g., "Renaissance Philosopher-Artist")
2. Persona emoji
3. Era (e.g., "15TH CENTURY FLORENCE" or "EARLY 20TH CENTURY PARIS" - must be up to and including 20th century, never 21st century)
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
  
  /// Helper: Call OpenAI API via proxy or directly
  static Future<Map<String, dynamic>> _callOpenAI(String prompt, {bool expectJson = true}) async {
    try {
      final stopwatch = Stopwatch()..start();
      
      if (_useProxy) {
        // Use proxy server
        final proxyUrl = _getProxyUrl();
        final uri = Uri.parse('$proxyUrl$_proxyApiPath');
        
        print('[AIAnalyzer] POST $uri via proxy (expectJson=$expectJson)');
        
        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            // No Authorization header needed - proxy handles it
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
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Request timeout after 30 seconds');
          },
        );
        
        stopwatch.stop();
        print('[AIAnalyzer] Proxy response ${response.statusCode} ${response.reasonPhrase} '
            '(${stopwatch.elapsedMilliseconds} ms)');
        
        if (response.statusCode >= 400) {
          print('[AIAnalyzer] Error body: ${response.body}');
          final errorData = jsonDecode(response.body);
          throw Exception(
            errorData['error'] ?? 'Proxy server error: ${response.statusCode}',
          );
        }
        
        if (response.statusCode != 200) {
          throw Exception('Proxy server error: ${response.statusCode} - ${response.body}');
        }
        
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        if (expectJson) {
          // Parse JSON response
          try {
            return jsonDecode(content);
          } catch (_) {
            final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
            if (jsonMatch != null) {
              return jsonDecode(jsonMatch.group(0)!);
            }
            throw Exception('Failed to parse JSON from OpenAI response: $content');
          }
        } else {
          // Return plain text
          return {'text': content.trim()};
        }
      } else {
        // Direct API call (legacy, not recommended)
        final apiKey = _resolveApiKey();
        final uri = Uri.parse(_directApiUrl);
        
        print('[AIAnalyzer] POST $uri directly (expectJson=$expectJson)');
        
        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': 'gpt-4o-mini',
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
        ).timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Request timeout after 30 seconds');
          },
        );
        
        stopwatch.stop();
        print('[AIAnalyzer] Direct API response ${response.statusCode} ${response.reasonPhrase} '
            '(${stopwatch.elapsedMilliseconds} ms)');
        
        if (response.statusCode >= 400) {
          print('[AIAnalyzer] Error body: ${response.body}');
        }
        
        if (response.statusCode != 200) {
          throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
        }
        
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        if (expectJson) {
          // Parse JSON response
          try {
            return jsonDecode(content);
          } catch (_) {
            final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(content);
            if (jsonMatch != null) {
              return jsonDecode(jsonMatch.group(0)!);
            }
            throw Exception('Failed to parse JSON from OpenAI response: $content');
          }
        } else {
          // Return plain text
          return {'text': content.trim()};
        }
      }
      
    } on SocketException catch (e) {
      print('Network error: $e');
      throw Exception('Network error: Unable to connect to server. Please check your internet connection.');
    } on FormatException catch (e) {
      print('JSON parsing error: $e');
      throw Exception('Invalid response from server. Please try again.');
    } catch (e) {
      print('Error calling OpenAI API: $e');
      rethrow;
    }
  }
}
















