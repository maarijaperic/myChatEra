import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/ai_analyzer.dart';

/// Premium insights data model
class PremiumInsights {
  // Type A/B Personality
  final String personalityType;
  final int typeAPercentage;
  final int typeBPercentage;
  final String typeExplanation;
  
  // Red and Green Flags
  final List<String> greenFlags;
  final List<String> redFlags;
  
  // Zodiac Sign
  final String zodiacName;
  final String zodiacSign;
  final String zodiacEmoji;
  final String zodiacExplanation;
  
  // Introvert vs Extrovert
  final String introExtroType;
  final int introvertPercentage;
  final int extrovertPercentage;
  final String introExtroExplanation;
  
  // Most Asked Advice
  final String mostAskedAdvice;
  final String adviceCategory;
  final String adviceEmoji;
  final String adviceExplanation;
  
  // Love Language
  final String loveLanguage;
  final String languageEmoji;
  final String loveLanguageExplanation;
  
  // MBTI
  final String mbtiType;
  final String mbtiEmoji;
  final String personalityName;
  final String mbtiExplanation;
  
  // Past Life Persona
  final String personaTitle;
  final String personaEmoji;
  final String era;
  final String personaDescription;
  
  // Roast
  final String roastText;

  PremiumInsights({
    required this.personalityType,
    required this.typeAPercentage,
    required this.typeBPercentage,
    required this.typeExplanation,
    required this.greenFlags,
    required this.redFlags,
    required this.zodiacName,
    required this.zodiacSign,
    required this.zodiacEmoji,
    required this.zodiacExplanation,
    required this.introExtroType,
    required this.introvertPercentage,
    required this.extrovertPercentage,
    required this.introExtroExplanation,
    required this.mostAskedAdvice,
    required this.adviceCategory,
    required this.adviceEmoji,
    required this.adviceExplanation,
    required this.loveLanguage,
    required this.languageEmoji,
    required this.loveLanguageExplanation,
    required this.mbtiType,
    required this.mbtiEmoji,
    required this.personalityName,
    required this.mbtiExplanation,
    required this.personaTitle,
    required this.personaEmoji,
    required this.era,
    required this.personaDescription,
    required this.roastText,
  });
}

/// Process premium insights using AI
class PremiumProcessor {
  /// Analyze conversations and generate all premium insights
  /// This will make multiple OpenAI API calls (~8-9 calls)
  /// Estimated cost: $0.01-0.02 per user
  static Future<PremiumInsights> analyzePremiumInsights(
    List<ConversationData> conversations,
    Function(String)? onProgress,
  ) async {
    // Extract all messages
    final allMessages = <MessageData>[];
    for (var conv in conversations) {
      allMessages.addAll(conv.messages);
    }
    
    if (allMessages.isEmpty) {
      throw Exception('No messages found in conversations');
    }
    
    // Only use user messages for analysis
    final userMessages = allMessages.where((m) => m.isUser).toList();
    
    if (userMessages.isEmpty) {
      throw Exception('No user messages found');
    }
    
    try {
      // 1. Analyze Type A/B Personality
      onProgress?.call('Analyzing personality type...');
      final personalityResult = await AIAnalyzer.analyzePersonalityType(userMessages);
      
      // 2. Analyze Red and Green Flags
      onProgress?.call('Identifying red and green flags...');
      final flagsResult = await AIAnalyzer.analyzeRedGreenFlags(userMessages);
      
      // 3. Analyze Love Language
      onProgress?.call('Determining love language...');
      final loveLanguageResult = await AIAnalyzer.analyzeLoveLanguage(userMessages);
      
      // 4. Analyze Introvert vs Extrovert
      onProgress?.call('Analyzing introvert vs extrovert...');
      final introExtroResult = await AIAnalyzer.analyzeIntrovertExtrovert(userMessages);
      
      // 5. Analyze MBTI
      onProgress?.call('Determining MBTI personality...');
      final mbtiResult = await AIAnalyzer.analyzeMBTI(userMessages);
      
      // 6. Guess Zodiac Sign
      onProgress?.call('Guessing zodiac sign...');
      final zodiacResult = await AIAnalyzer.guessZodiacSign(userMessages);
      
      // 7. Analyze Most Asked Advice
      onProgress?.call('Finding most asked advice...');
      final adviceResult = await AIAnalyzer.analyzeMostAskedAdvice(userMessages);
      
      // 8. Generate Roast
      onProgress?.call('Generating roast...');
      final roastText = await AIAnalyzer.generateRoast(userMessages);
      
      // 9. Analyze Past Life Persona
      onProgress?.call('Revealing past life persona...');
      final personaResult = await AIAnalyzer.analyzePastLifePersona(userMessages);
      
      onProgress?.call('Complete!');
      
      // Combine all results
      return PremiumInsights(
        personalityType: personalityResult['personalityType'] ?? 'TYPE A',
        typeAPercentage: personalityResult['typeAPercentage'] ?? 50,
        typeBPercentage: personalityResult['typeBPercentage'] ?? 50,
        typeExplanation: personalityResult['explanation'] ?? '',
        greenFlags: List<String>.from(flagsResult['greenFlags'] ?? []),
        redFlags: List<String>.from(flagsResult['redFlags'] ?? []),
        zodiacName: zodiacResult['zodiacName'] ?? 'Gemini',
        zodiacSign: zodiacResult['zodiacSign'] ?? 'Gemini ♊',
        zodiacEmoji: zodiacResult['zodiacEmoji'] ?? '♊',
        zodiacExplanation: zodiacResult['explanation'] ?? '',
        introExtroType: introExtroResult['personalityType'] ?? 'AMBIVERT',
        introvertPercentage: introExtroResult['introvertPercentage'] ?? 50,
        extrovertPercentage: introExtroResult['extrovertPercentage'] ?? 50,
        introExtroExplanation: introExtroResult['explanation'] ?? '',
        mostAskedAdvice: adviceResult['mostAskedAdvice'] ?? 'General advice',
        adviceCategory: adviceResult['adviceCategory'] ?? 'GENERAL',
        adviceEmoji: adviceResult['adviceEmoji'] ?? '💡',
        adviceExplanation: adviceResult['explanation'] ?? '',
        loveLanguage: loveLanguageResult['loveLanguage'] ?? 'Words of Affirmation',
        languageEmoji: loveLanguageResult['languageEmoji'] ?? '💬',
        loveLanguageExplanation: loveLanguageResult['explanation'] ?? '',
        mbtiType: mbtiResult['mbtiType'] ?? 'ENFP',
        mbtiEmoji: mbtiResult['mbtiEmoji'] ?? '🎭',
        personalityName: mbtiResult['personalityName'] ?? 'The Enthusiast',
        mbtiExplanation: mbtiResult['explanation'] ?? '',
        personaTitle: personaResult['personaTitle'] ?? 'Ancient Philosopher',
        personaEmoji: personaResult['personaEmoji'] ?? '🏛️',
        era: personaResult['era'] ?? 'ANCIENT GREECE',
        personaDescription: personaResult['description'] ?? '',
        roastText: roastText,
      );
      
    } catch (e) {
      print('Error analyzing premium insights: $e');
      rethrow;
    }
  }
  
  /// Create demo premium insights for testing
  static PremiumInsights createDemoInsights() {
    return PremiumInsights(
      personalityType: 'TYPE A',
      typeAPercentage: 70,
      typeBPercentage: 30,
      typeExplanation: 'Based on your conversations, GPT detected strong Type A traits. You\'re ambitious, organized, and impatient—probably asking follow-up questions before the first answer even finishes. You multitask like a pro, demand efficiency, and low-key stress about everything. But hey, at least you get stuff done. 💪',
      greenFlags: [
        'You always apologize when you make a mistake',
        'You are very creative with your prompts',
        'You ask very intelligent questions',
        'You have a good sense of humor',
        'You are patient with long answers',
      ],
      redFlags: [
        'Sometimes you don\'t read the full answers',
        'You ask for the same thing several times in a row',
        'You don\'t specify what you want clearly',
        'You get frustrated when you don\'t understand something',
        'Sometimes you are very impatient',
      ],
      zodiacName: 'Scorpio',
      zodiacSign: 'Scorpio ♏',
      zodiacEmoji: '🦂',
      zodiacExplanation: 'Based on your chats, you\'re giving major Scorpio energy 🦂✨ Intense conversations? Check. Deep questions at 3 AM? Check. Reading between every single line? That\'s so you. GPT says you\'re the friend who turns small talk into therapy sessions. Mysterious vibes only. 💅',
      introExtroType: 'AMBIVERT',
      introvertPercentage: 55,
      extrovertPercentage: 45,
      introExtroExplanation: 'According to your conversations, ChatGPT detected that you have a balanced personality. You are an ambivert: you enjoy both moments of solitary reflection and social interactions.',
      mostAskedAdvice: 'How to improve my personal relationships',
      adviceCategory: 'RELATIONSHIPS',
      adviceEmoji: '💕',
      adviceExplanation: 'According to the analysis of your conversations, you have sought advice about personal relationships more than any other topic.',
      loveLanguage: 'Words of Affirmation',
      languageEmoji: '💬',
      loveLanguageExplanation: 'Based on your chats, GPT noticed you light up when validated. You seek reassurance, ask follow-up questions to make sure you\'re understood, and appreciate detailed explanations.',
      mbtiType: 'ENFP',
      mbtiEmoji: '🎭',
      personalityName: 'The Enthusiast',
      mbtiExplanation: 'According to the analysis of your conversations, ChatGPT detected that you are an ENFP (Extroverted, Intuitive, Feeling, Perceiving).',
      personaTitle: 'Renaissance Philosopher-Artist',
      personaEmoji: '🎨',
      era: '15TH CENTURY FLORENCE',
      personaDescription: 'You were a Renaissance thinker who questioned everything and created beauty from chaos. Your conversations reveal a mind that blends logic with creativity, always seeking deeper meaning.',
      roastText: 'You ask ChatGPT for life advice at 3 AM like it\'s your therapist, career coach, and life guru all in one. You literally have more deep conversations with an AI than with actual humans. Your search history is 60% "how to be productive" and 40% asking GPT to validate your life choices. GPT knows more about your problems than your best friend does. But hey, at least you\'re self-aware... or are you just asking GPT if you are? 💀😂',
    );
  }
}













