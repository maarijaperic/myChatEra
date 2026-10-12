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

  // Movie Recommendation
  final String movieTitle;
  final int movieYear;
  final String movieExplanation;
  
  // Song Recommendation
  final String songTitle;
  final String songArtist;
  final int songYear;
  final String songExplanation;

  // Chart data (empty when the AI didn't return it; screens fall back)
  final Map<String, int> mbtiDimensions;
  final Map<String, int> zodiacElements;
  final List<String> introExtroTraits;
  final String adviceRoast;
  final Map<String, int> adviceTopics;
  final Map<String, int> loveLanguagePercentages;
  final int roastHeat;
  final Map<String, int> roastMeters;
  final double movieRating;
  final List<String> movieGenres;
  final Map<String, int> movieScores;
  final Map<String, int> songVibe;
  final int songDurationSeconds;

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
    required this.movieTitle,
    required this.movieYear,
    required this.movieExplanation,
    required this.songTitle,
    required this.songArtist,
    required this.songYear,
    required this.songExplanation,
    this.mbtiDimensions = const {},
    this.zodiacElements = const {},
    this.introExtroTraits = const [],
    this.adviceRoast = '',
    this.adviceTopics = const {},
    this.loveLanguagePercentages = const {},
    this.roastHeat = 0,
    this.roastMeters = const {},
    this.movieRating = 0,
    this.movieGenres = const [],
    this.movieScores = const {},
    this.songVibe = const {},
    this.songDurationSeconds = 0,
  });
}

Map<String, int> _intMap(dynamic value) {
  if (value is! Map) return const {};
  final result = <String, int>{};
  value.forEach((key, v) {
    final parsed = v is num ? v.round() : int.tryParse('$v');
    if (parsed != null) result['$key'] = parsed.clamp(0, 100);
  });
  return result;
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList();
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
      print('Premium debug — personalityResult: $personalityResult');
      
      // 2. Analyze Red and Green Flags
      onProgress?.call('Identifying red and green flags...');
      final flagsResult = await AIAnalyzer.analyzeRedGreenFlags(userMessages);
      print('Premium debug — flagsResult: $flagsResult');
      
      // 3. Analyze Love Language
      onProgress?.call('Determining love language...');
      final loveLanguageResult = await AIAnalyzer.analyzeLoveLanguage(userMessages);
      print('Premium debug — loveLanguageResult: $loveLanguageResult');
      
      // 4. Analyze Introvert vs Extrovert
      onProgress?.call('Analyzing introvert vs extrovert...');
      final introExtroResult = await AIAnalyzer.analyzeIntrovertExtrovert(userMessages);
      print('Premium debug — introExtroResult: $introExtroResult');
      
      // 5. Analyze MBTI
      onProgress?.call('Determining MBTI personality...');
      final mbtiResult = await AIAnalyzer.analyzeMBTI(userMessages);
      print('Premium debug — mbtiResult: $mbtiResult');
      
      // 6. Guess Zodiac Sign
      onProgress?.call('Guessing zodiac sign...');
      final zodiacResult = await AIAnalyzer.guessZodiacSign(userMessages);
      print('Premium debug — zodiacResult: $zodiacResult');
      
      // 7. Analyze Most Asked Advice
      onProgress?.call('Finding most asked advice...');
      final adviceResult = await AIAnalyzer.analyzeMostAskedAdvice(userMessages);
      print('Premium debug — adviceResult: $adviceResult');
      
      // 8. Generate Roast
      onProgress?.call('Generating roast...');
      final roastResult = await AIAnalyzer.generateRoast(userMessages);
      final roastText = '${roastResult['roast'] ?? ''}'.trim().isNotEmpty
          ? '${roastResult['roast']}'.trim()
          : 'You ask ChatGPT everything. Like... everything. 💀';
      print('Premium debug — roastResult: $roastResult');

      // 9. Determine movie title
      onProgress?.call('Matching your movie title...');
      final movieResult = await AIAnalyzer.generateMovieTitle(userMessages);
      print('Premium debug — movieResult: $movieResult');
      
      // 10. Determine song title
      onProgress?.call('Finding your life soundtrack...');
      final songResult = await AIAnalyzer.generateSongTitle(userMessages);
      print('Premium debug — songResult: $songResult');
      
      // 11. Analyze Past Life Persona
      onProgress?.call('Revealing past life persona...');
      final personaResult = await AIAnalyzer.analyzePastLifePersona(userMessages);
      print('Premium debug — personaResult: $personaResult');
      
      onProgress?.call('Complete!');
      
      // Debug: Print raw values before creating PremiumInsights
      print('Premium debug — Raw values before creating PremiumInsights:');
      print('  personalityResult[personalityType]: ${personalityResult['personalityType']}');
      print('  personalityResult[typeAPercentage]: ${personalityResult['typeAPercentage']}');
      print('  introExtroResult[personalityType]: ${introExtroResult['personalityType']}');
      print('  mbtiResult[mbtiType]: ${mbtiResult['mbtiType']}');
      print('  zodiacResult[zodiacName]: ${zodiacResult['zodiacName']}');
      print('  loveLanguageResult[loveLanguage]: ${loveLanguageResult['loveLanguage']}');
      print('  movieResult[movieTitle]: ${movieResult['movieTitle']}');
      print('  songResult[songTitle]: ${songResult['songTitle']}');
      
      // Combine all results
      final insights = PremiumInsights(
        personalityType: personalityResult['personalityType'] ?? 'TYPE A',
        typeAPercentage: personalityResult['typeAPercentage'] ?? 50,
        typeBPercentage: personalityResult['typeBPercentage'] ?? 50,
        typeExplanation: personalityResult['explanation'] ?? '',
        greenFlags: flagsResult['greenFlags'] != null && flagsResult['greenFlags'] is List
            ? List<String>.from((flagsResult['greenFlags'] as List).map((e) => e.toString()))
            : [],
        redFlags: flagsResult['redFlags'] != null && flagsResult['redFlags'] is List
            ? List<String>.from((flagsResult['redFlags'] as List).map((e) => e.toString()))
            : [],
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
        movieTitle: movieResult['movieTitle'] ?? 'The Pursuit of Happyness',
        movieYear: int.tryParse('${movieResult['releaseYear']}') ?? 2006,
        movieExplanation: movieResult['explanation'] ?? 'Based on your conversations, GPT detected a relentless drive for self-improvement and asking deep questions about life. Like Chris Gardner in the movie, you are constantly searching for answers, optimizing your life, and never giving up on personal growth. Your chats are basically a journey of someone trying to figure it all out - one prompt at a time.',
        songTitle: songResult['songTitle'] ?? 'Don\'t Stop Believin\'',
        songArtist: songResult['artist'] ?? 'Journey',
        songYear: int.tryParse('${songResult['releaseYear']}') ?? 1981,
        songExplanation: songResult['explanation'] ?? 'Based on your conversations, GPT detected an optimistic and persistent personality. Like this classic anthem, you keep pushing forward, asking questions, and never giving up on your goals. Your chats are the soundtrack of someone who believes in the journey, not just the destination.',
        mbtiDimensions: _intMap(mbtiResult['dimensions']),
        zodiacElements: _intMap(zodiacResult['elements']),
        introExtroTraits: _stringList(introExtroResult['traits']),
        adviceRoast: '${adviceResult['roast'] ?? ''}'.trim(),
        adviceTopics: _intMap(adviceResult['topics']),
        loveLanguagePercentages: _intMap(loveLanguageResult['percentages']),
        roastHeat: (num.tryParse('${roastResult['heat']}') ?? 0).round().clamp(0, 100),
        roastMeters: _intMap(roastResult['meters']),
        movieRating: (double.tryParse('${movieResult['lifeRating']}') ?? 0).clamp(0.0, 10.0),
        movieGenres: _stringList(movieResult['genres']),
        movieScores: _intMap(movieResult['scores']),
        songVibe: _intMap(songResult['vibe']),
        songDurationSeconds: int.tryParse('${songResult['durationSeconds']}') ?? 0,
      );
      
      print('🔴 PREMIUM_DEBUG: Created PremiumInsights - personalityType: ${insights.personalityType}, mbtiType: ${insights.mbtiType}, zodiacName: ${insights.zodiacName}');
      
      return insights;
      
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
        'You apologize when you make mistakes',
        'You create creative prompts',
        'You ask thoughtful questions',
        'You have a good sense of humor',
        'You stay patient with long answers',
      ],
      redFlags: [
        'You sometimes skip reading full answers',
        'You repeat the same questions',
        'You don\'t specify what you want clearly',
        'You get frustrated easily',
        'You can be impatient',
      ],
      zodiacName: 'Scorpio',
      zodiacSign: 'Scorpio ♏',
      zodiacEmoji: '🦂',
      zodiacExplanation: 'Based on your chats, you\'re giving major Scorpio energy 🦂✨ Intense conversations? Check. Deep questions at 3 AM? Check. Reading between every single line? That\'s so you. GPT says you\'re the friend who turns small talk into therapy sessions. Mysterious vibes only. 💅',
      introExtroType: 'AMBIVERT',
      introvertPercentage: 55,
      extrovertPercentage: 45,
      introExtroExplanation: 'According to your conversations, you have a *balanced personality*. You enjoy both *moments of solitary reflection* and *social interactions*, switching modes depending on your mood.',
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
      movieTitle: 'The Pursuit of Happyness',
      movieYear: 2006,
      movieExplanation: 'Based on your conversations, GPT detected a relentless drive for self-improvement and asking deep questions about life. Like Chris Gardner in the movie, you are constantly searching for answers, optimizing your life, and never giving up on personal growth. Your chats are basically a journey of someone trying to figure it all out - one prompt at a time.',
      songTitle: 'Don\'t Stop Believin\'',
      songArtist: 'Journey',
      songYear: 1981,
      songExplanation: 'Based on your conversations, GPT detected an optimistic and persistent personality. Like this classic anthem, you keep pushing forward, asking questions, and never giving up on your goals. Your chats are the soundtrack of someone who believes in the journey, not just the destination.',
      mbtiDimensions: const {'E': 68, 'N': 74, 'F': 61, 'P': 57},
      zodiacElements: const {'Water': 45, 'Fire': 22, 'Air': 18, 'Earth': 15},
      introExtroTraits: const ['Deep talks', 'Recharges solo', 'Selective circle', 'Great listener'],
      adviceRoast: 'You\'ve asked how to fix your relationships so many times that ChatGPT is basically your couples therapist, except it\'s just you on the couch. 💀',
      adviceTopics: const {'Relationships': 42, 'Career': 26, 'Self-growth': 19, 'Health': 13},
      loveLanguagePercentages: const {
        'Words of Affirmation': 38,
        'Quality Time': 24,
        'Acts of Service': 16,
        'Physical Touch': 12,
        'Receiving Gifts': 10,
      },
      roastHeat: 87,
      roastMeters: const {'3 AM questions': 92, 'Overthinking': 85, 'Needs validation': 71, 'Procrastination': 64},
      movieRating: 8.6,
      movieGenres: const ['Drama', 'Biography'],
      movieScores: const {'Drama': 82, 'Plot twists': 71, 'Comedy': 54, 'Romance': 38},
      songVibe: const {'Energy': 78, 'Mood': 84, 'Danceability': 61},
      songDurationSeconds: 251,
    );
  }
}

















