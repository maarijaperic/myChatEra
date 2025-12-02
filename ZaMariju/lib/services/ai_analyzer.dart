import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
Analyze these ChatGPT conversation messages and identify the user's red and green flags based on their actual conversation patterns, communication style, and interaction behavior.

User messages:
${messagesSample.join('\n')}

IMPORTANT: Analyze the ACTUAL messages above. Do NOT use generic examples. Base your analysis on:
- How the user communicates (tone, style, language patterns)
- What topics they discuss
- How they ask questions
- Their response patterns
- Their interaction style with ChatGPT

Provide:
1. 5 green flags (positive traits based on their ACTUAL interactions - be specific to their messages)
2. 5 red flags (areas for improvement based on their ACTUAL behavior - be playful not harsh, specific to their messages)

CRITICAL FORMATTING RULES:
- Write each flag as a SHORT sentence in SECOND PERSON SINGULAR (use "you" and "your")
- Keep each flag to ONE sentence maximum
- Do NOT use "The user demonstrates..." or "The user shows..." - write directly to the user
- Be concise and direct
- Examples of good format: "You ask thoughtful follow-up questions", "You sometimes skip reading full answers"
- Examples of BAD format: "The user demonstrates patience", "The user shows impatience"

Each flag should be unique to this user's conversation style, not generic examples.

Respond ONLY with valid JSON in this exact format:
{
  "greenFlags": [
    "You [specific positive trait]",
    "You [another specific positive trait]",
    "You [another specific positive trait]",
    "You [another specific positive trait]",
    "You [another specific positive trait]"
  ],
  "redFlags": [
    "You [specific area for improvement]",
    "You [another specific area for improvement]",
    "You [another specific area for improvement]",
    "You [another specific area for improvement]",
    "You [another specific area for improvement]"
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

IMPORTANT: Choose from a diverse range of movies. Avoid repeating common choices. Consider these categories for inspiration:

DRAMA/INSPIRATIONAL:
- The Pursuit of Happyness (2006), Good Will Hunting (1997), The Shawshank Redemption (1994), A Beautiful Mind (2001), The Theory of Everything (2014), Hidden Figures (2016), The Imitation Game (2014), The Social Network (2010), Moneyball (2011), The Intern (2015)

COMEDY/LIGHTHEARTED:
- The Devil Wears Prada (2006), Legally Blonde (2001), Mean Girls (2004), The Internship (2013), Yes Man (2008), The Secret Life of Walter Mitty (2013), Chef (2014), The Grand Budapest Hotel (2014), Little Miss Sunshine (2006), Juno (2007)

ADVENTURE/ACTION:
- Into the Wild (2007), The Secret Life of Walter Mitty (2013), The Martian (2015), Interstellar (2014), Inception (2010), The Matrix (1999), Blade Runner 2049 (2017), Arrival (2016), Ex Machina (2014), Her (2013)

ROMANTIC/RELATIONSHIPS:
- 500 Days of Summer (2009), La La Land (2016), Before Sunrise (1995), The Notebook (2004), Eternal Sunshine of the Spotless Mind (2004), Lost in Translation (2003), Amélie (2001), Silver Linings Playbook (2012), Crazy Stupid Love (2011), The Fault in Our Stars (2014)

THRILLER/MYSTERY:
- Gone Girl (2014), Shutter Island (2010), The Prestige (2006), Memento (2000), Se7en (1995), Zodiac (2007), The Girl with the Dragon Tattoo (2011), Prisoners (2013), Nightcrawler (2014), Parasite (2019)

SCIFI/FUTURISTIC:
- Her (2013), Ex Machina (2014), Blade Runner (1982), The Matrix (1999), Arrival (2016), Interstellar (2014), Inception (2010), Minority Report (2002), Gattaca (1997), The Truman Show (1998)

INDIE/ARTISTIC:
- Little Miss Sunshine (2006), Juno (2007), The Grand Budapest Hotel (2014), Moonrise Kingdom (2012), The Royal Tenenbaums (2001), Lost in Translation (2003), Amélie (2001), Eternal Sunshine of the Spotless Mind (2004), The Lobster (2015), Birdman (2014)

CLASSICS:
- Casablanca (1942), The Godfather (1972), Citizen Kane (1941), 12 Angry Men (1957), To Kill a Mockingbird (1962), The Graduate (1967), Annie Hall (1977), Taxi Driver (1976), One Flew Over the Cuckoo's Nest (1975), Apocalypse Now (1979)

MODERN HITS:
- Everything Everywhere All at Once (2022), Parasite (2019), Get Out (2017), Lady Bird (2017), Call Me by Your Name (2017), The Shape of Water (2017), Moonlight (2016), Whiplash (2014), The Grand Budapest Hotel (2014), Her (2013)

INTERNATIONAL:
- Parasite (2019), Amélie (2001), Crouching Tiger Hidden Dragon (2000), Life is Beautiful (1997), Cinema Paradiso (1988), Oldboy (2003), Spirited Away (2001), Amores Perros (2000), City of God (2002), Pan's Labyrinth (2006)

Choose a movie that genuinely matches the user's personality and conversation style. Be creative and avoid the most obvious choices. Pick from different decades and genres to ensure variety.

Provide:
1. Movie title (string) - must be a real, well-known movie
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

  /// Generate a song title that matches the user's chat vibe
  static Future<Map<String, dynamic>> generateSongTitle(
    List<MessageData> userMessages,
  ) async {
    final messagesSample = _getSampleMessages(userMessages, maxCount: 40);
    
    final prompt = '''
Analyze these ChatGPT conversation messages and pick a song that best represents the user's overall vibe, journey, and personality.

User messages:
${messagesSample.join('\n')}

IMPORTANT: Choose from a diverse range of songs. Avoid repeating common choices. Consider these categories for inspiration:

POP/MAINSTREAM:
- "Blinding Lights" by The Weeknd (2019), "Shape of You" by Ed Sheeran (2017), "Watermelon Sugar" by Harry Styles (2019), "Levitating" by Dua Lipa (2020), "Good 4 U" by Olivia Rodrigo (2021), "As It Was" by Harry Styles (2022), "Flowers" by Miley Cyrus (2023), "Anti-Hero" by Taylor Swift (2022), "Unholy" by Sam Smith (2022), "About Damn Time" by Lizzo (2022)

ROCK/CLASSIC ROCK:
- "Don't Stop Believin'" by Journey (1981), "Bohemian Rhapsody" by Queen (1975), "Stairway to Heaven" by Led Zeppelin (1971), "Hotel California" by Eagles (1976), "Sweet Child O' Mine" by Guns N' Roses (1987), "Wonderwall" by Oasis (1995), "Smells Like Teen Spirit" by Nirvana (1991), "Livin' on a Prayer" by Bon Jovi (1986), "We Will Rock You" by Queen (1977), "Eye of the Tiger" by Survivor (1982)

INDIE/ALTERNATIVE:
- "Somebody That I Used to Know" by Gotye (2011), "Pumped Up Kicks" by Foster the People (2010), "Riptide" by Vance Joy (2013), "Ho Hey" by The Lumineers (2012), "Home" by Edward Sharpe & The Magnetic Zeros (2009), "Dog Days Are Over" by Florence + The Machine (2008), "Little Talks" by Of Monsters and Men (2011), "Shake It Out" by Florence + The Machine (2011), "Tongue Tied" by Grouplove (2011), "Young Folks" by Peter Bjorn and John (2006)

R&B/SOUL:
- "Blame It" by Jamie Foxx (2008), "Ordinary People" by John Legend (2004), "All of Me" by John Legend (2013), "Thinking Out Loud" by Ed Sheeran (2014), "Stay" by Rihanna (2012), "Love on Top" by Beyoncé (2011), "Adorn" by Miguel (2012), "Best Part" by Daniel Caesar (2017), "Location" by Khalid (2016), "Redbone" by Childish Gambino (2016)

HIP-HOP/RAP:
- "Lose Yourself" by Eminem (2002), "Stronger" by Kanye West (2007), "Empire State of Mind" by Jay-Z (2009), "God's Plan" by Drake (2018), "Sicko Mode" by Travis Scott (2018), "Old Town Road" by Lil Nas X (2019), "The Box" by Roddy Ricch (2019), "Industry Baby" by Lil Nas X (2021), "Heat Waves" by Glass Animals (2020), "Good as Hell" by Lizzo (2019)

ELECTRONIC/DANCE:
- "One More Time" by Daft Punk (2000), "Titanium" by David Guetta (2011), "Wake Me Up" by Avicii (2013), "Clarity" by Zedd (2012), "Rather Be" by Clean Bandit (2013), "Lean On" by Major Lazer (2015), "Something Just Like This" by The Chainsmokers (2017), "Midnight City" by M83 (2011), "Summertime Sadness" by Lana Del Rey (2012), "Get Lucky" by Daft Punk (2013)

COUNTRY:
- "Wagon Wheel" by Old Crow Medicine Show (2004), "Before He Cheats" by Carrie Underwood (2005), "Need You Now" by Lady A (2009), "Cruise" by Florida Georgia Line (2012), "Die a Happy Man" by Thomas Rhett (2015), "Body Like a Back Road" by Sam Hunt (2016), "Tennessee Whiskey" by Chris Stapleton (2015), "The House That Built Me" by Miranda Lambert (2009), "Jolene" by Dolly Parton (1973), "Friends in Low Places" by Garth Brooks (1990)

FOLK/ACOUSTIC:
- "Hallelujah" by Leonard Cohen (1984), "The Sound of Silence" by Simon & Garfunkel (1964), "Landslide" by Fleetwood Mac (1975), "Fast Car" by Tracy Chapman (1988), "Black" by Pearl Jam (1991), "Mad World" by Tears for Fears (1982), "Creep" by Radiohead (1992), "Bitter Sweet Symphony" by The Verve (1997), "Fix You" by Coldplay (2005), "Yellow" by Coldplay (2000)

CLASSIC/OLDIES:
- "What a Wonderful World" by Louis Armstrong (1967), "Imagine" by John Lennon (1971), "Here Comes the Sun" by The Beatles (1969), "Let It Be" by The Beatles (1970), "Bridge Over Troubled Water" by Simon & Garfunkel (1970), "Stand by Me" by Ben E. King (1961), "Ain't No Mountain High Enough" by Marvin Gaye (1967), "Respect" by Aretha Franklin (1967), "I Will Always Love You" by Whitney Houston (1992), "My Way" by Frank Sinatra (1969)

EMOTIONAL/BALLADS:
- "Someone Like You" by Adele (2011), "Hello" by Adele (2015), "All of Me" by John Legend (2013), "Say Something" by A Great Big World (2013), "Stay" by Rihanna (2012), "Fix You" by Coldplay (2005), "Hurt" by Johnny Cash (2002), "The Scientist" by Coldplay (2002), "Skinny Love" by Bon Iver (2007), "Gravity" by John Mayer (2006)

EMPOWERING/INSPIRATIONAL:
- "Fight Song" by Rachel Platten (2015), "Roar" by Katy Perry (2013), "Stronger" by Kelly Clarkson (2011), "Brave" by Sara Bareilles (2013), "Rise Up" by Andra Day (2015), "I Will Survive" by Gloria Gaynor (1978), "Survivor" by Destiny's Child (2001), "I'm Still Standing" by Elton John (1983), "Eye of the Tiger" by Survivor (1982), "We Are the Champions" by Queen (1977)

Choose a song that genuinely matches the user's personality and conversation style. Be creative and avoid the most obvious choices. Pick from different decades and genres to ensure variety.

Provide:
1. Song title (string) - must be a real, well-known song
2. Artist name (string) - the performer/band
3. Release year (integer between 1960 and 2025)
4. Fun explanation (3-4 sentences, musical tone, direct "you" language, references how the chats match the song's themes and lyrics)

Respond ONLY with valid JSON in this exact format:
{
  "songTitle": "Don't Stop Believin'",
  "artist": "Journey",
  "releaseYear": 1981,
  "explanation": "Based on your conversations, GPT detected an optimistic and persistent personality. Like this classic anthem, you keep pushing forward, asking questions, and never giving up on your goals. Your chats are the soundtrack of someone who believes in the journey, not just the destination. You're basically living your own version of this song - always searching, always moving forward."
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
  
  /// Analyze monthly topics from conversations (for Monthly Obsessions)
  /// Extracts topics from user's chats and maps them to valid categories
  /// Returns topics for months 1-6 (Jan-Jun) or 7-12 (Jul-Dec) based on startMonth
  static List<Map<String, dynamic>> analyzeMonthlyTopics(
    List<ConversationData> conversations, {
    int startMonth = 1, // 1 for Jan-Jun, 7 for Jul-Dec
  }) {
    if (conversations.isEmpty) {
      return [];
    }
    
    // Valid topic categories that can be used
    final validCategories = [
      'Your Ex',
      'Healing',
      'Therapy',
      'Self-Care',
      'Baking',
      'Programming',
      'Writing',
      'Learning',
      'Career',
      'Health',
      'Travel',
      'Cooking',
      'Art',
      'Music',
      'Gaming',
      'Relationships',
      'Finance',
      'Productivity',
      'Science',
      'Philosophy',
    ];
    
    // Group conversations by month
    final monthlyGroups = <int, List<ConversationData>>{};
    for (var conv in conversations) {
      final month = conv.createTime.month;
      monthlyGroups.putIfAbsent(month, () => []).add(conv);
    }
    
    // Extract topics for each month
    final monthlyTopics = <Map<String, dynamic>>[];
    final monthNames = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 
                        'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];
    final colors = [
      [Color(0xFFFFE5E5), Color(0xFFFF6B6B)], // Jan - Red
      [Color(0xFFFFF0E5), Color(0xFFFF8C42)], // Feb - Orange
      [Color(0xFFE5F5FF), Color(0xFF4A90E2)], // Mar - Blue
      [Color(0xFFF0E5FF), Color(0xFF9B59B6)], // Apr - Purple
      [Color(0xFFE5FFE5), Color(0xFF2ECC71)], // May - Green
      [Color(0xFFFFF5E5), Color(0xFFFFB84D)], // Jun - Yellow
      [Color(0xFFFFF5E5), Color(0xFFFFB84D)], // Jul - Yellow
      [Color(0xFFE5F5FF), Color(0xFF4A90E2)], // Aug - Blue
      [Color(0xFFF0E5FF), Color(0xFF9B59B6)], // Sep - Purple
      [Color(0xFFFFF0E5), Color(0xFFFF8C42)], // Oct - Orange
      [Color(0xFFE5FFE5), Color(0xFF2ECC71)], // Nov - Green
      [Color(0xFFFFE5FF), Color(0xFFFF6B9D)], // Dec - Pink
    ];
    
    // Track topic usage to prevent more than 2 repetitions
    final topicUsageCount = <String, int>{};
    String? previousTopic;
    bool allowConsecutive = true; // Allow one consecutive repetition
    int consecutiveCount = 0;
    
    // Shuffle valid categories for fallback randomness
    final shuffledCategories = List<String>.from(validCategories);
    shuffledCategories.shuffle();
    
    // Analyze topics for specified months
    final endMonth = startMonth + 5; // 6 months total
    for (int month = startMonth; month <= endMonth && month <= 12; month++) {
      final monthConvs = monthlyGroups[month] ?? [];
      String topic;
      bool isConsecutive = false;
      
      // Try to extract topic from conversations for this month
      if (monthConvs.isNotEmpty) {
        // Extract topic from conversations and map to valid category
        final extractedTopic = _extractTopicFromConversations(monthConvs);
        
        // Check if extracted topic is a valid category
        if (validCategories.contains(extractedTopic)) {
          topic = extractedTopic;
        } else {
          // Map to valid category based on keywords
          topic = _mapToValidCategory(extractedTopic, validCategories);
        }
      } else {
        // No conversations for this month - use random valid category
        final available = shuffledCategories.where((t) {
          final key = t.toLowerCase();
          return (topicUsageCount[key] ?? 0) < 2;
        }).toList();
        
        if (available.isEmpty) {
          topic = shuffledCategories[month % shuffledCategories.length];
        } else {
          final random = (month * 17 + startMonth * 23) % available.length;
          topic = available[random];
        }
      }
      
      // Check if topic is used too many times (max 2)
      final topicKey = topic.toLowerCase();
      final usageCount = topicUsageCount[topicKey] ?? 0;
      if (usageCount >= 2) {
        // Find alternative valid category that hasn't been used 2 times
        final available = shuffledCategories.where((t) {
          final key = t.toLowerCase();
          return (topicUsageCount[key] ?? 0) < 2 && t != topic;
        }).toList();
        
        if (available.isNotEmpty) {
          final random = (month * 19 + startMonth * 31) % available.length;
          topic = available[random];
        }
      }
      
      // Check if it's consecutive (same as previous)
      if (previousTopic != null && topic == previousTopic) {
        if (allowConsecutive && consecutiveCount == 0) {
          // Allow one consecutive, mark it
          isConsecutive = true;
          consecutiveCount = 1;
          allowConsecutive = false; // Don't allow more consecutive
        } else {
          // Find different topic
          final available = shuffledCategories.where((t) {
            final key = t.toLowerCase();
            return (topicUsageCount[key] ?? 0) < 2 && t != previousTopic;
          }).toList();
          
          if (available.isNotEmpty) {
            final random2 = (month * 19 + startMonth * 31) % available.length;
            topic = available[random2];
          }
          consecutiveCount = 0;
        }
      } else {
        consecutiveCount = 0;
      }
      
      // Increment usage count
      topicUsageCount[topicKey] = (topicUsageCount[topicKey] ?? 0) + 1;
      
      final emoji = _getEmojiForTopic(topic);
      
      monthlyTopics.add({
        'month': monthNames[month - 1],
        'obsession': topic,
        'sentence': _generateSentenceForTopic(topic, month, isConsecutive: isConsecutive),
        'emoji': emoji,
        'color': colors[month - 1][0],
        'accentColor': colors[month - 1][1],
      });
      
      previousTopic = topic;
    }
    
    return monthlyTopics;
  }
  
  /// Map extracted topic to a valid category
  static String _mapToValidCategory(String extractedTopic, List<String> validCategories) {
    final topicLower = extractedTopic.toLowerCase();
    
    // Map of keywords to valid categories
    final keywordMap = {
      'Your Ex': ['ex', 'breakup', 'former', 'past relationship', 'split', 'divorce'],
      'Healing': ['healing', 'heal', 'recovery', 'recover', 'trauma'],
      'Therapy': ['therapy', 'therapist', 'counseling', 'mental health'],
      'Self-Care': ['self-care', 'self care', 'wellness', 'self-love', 'self improvement'],
      'Baking': ['baking', 'bake', 'cake', 'cookies', 'pastry', 'dessert'],
      'Programming': ['code', 'program', 'python', 'javascript', 'java', 'react', 'flutter', 'developer', 'coding'],
      'Writing': ['write', 'story', 'essay', 'article', 'blog', 'poem', 'novel', 'author', 'book'],
      'Learning': ['learn', 'study', 'course', 'tutorial', 'education', 'school', 'university', 'exam'],
      'Career': ['work', 'career', 'job', 'interview', 'resume', 'professional', 'business', 'company'],
      'Health': ['health', 'fitness', 'exercise', 'workout', 'gym', 'diet', 'nutrition', 'yoga'],
      'Travel': ['travel', 'trip', 'vacation', 'hotel', 'flight', 'destination', 'adventure'],
      'Cooking': ['cook', 'food', 'recipe', 'kitchen', 'meal', 'restaurant', 'cuisine'],
      'Art': ['art', 'design', 'drawing', 'painting', 'sketch', 'illustration', 'graphic', 'artist'],
      'Music': ['music', 'song', 'album', 'artist', 'band', 'concert', 'piano', 'guitar'],
      'Gaming': ['game', 'gaming', 'play', 'player', 'level', 'quest', 'strategy', 'console'],
      'Relationships': ['love', 'relationship', 'dating', 'partner', 'friend', 'family', 'marriage', 'romance'],
      'Finance': ['money', 'finance', 'budget', 'investment', 'saving', 'bank', 'credit', 'stock'],
      'Productivity': ['productivity', 'planning', 'organize', 'schedule', 'task', 'goal', 'project', 'time'],
      'Science': ['science', 'research', 'experiment', 'theory', 'data', 'analysis', 'physics', 'chemistry'],
      'Philosophy': ['philosophy', 'meaning', 'life', 'exist', 'think', 'question', 'truth', 'wisdom'],
    };
    
    // Try to find matching category
    for (final entry in keywordMap.entries) {
      if (entry.value.any((keyword) => topicLower.contains(keyword))) {
        if (validCategories.contains(entry.key)) {
          return entry.key;
        }
      }
    }
    
    // If no match, return random valid category
    return validCategories[extractedTopic.hashCode.abs() % validCategories.length];
  }
  
  /// Extract all unique topics from all conversations
  static List<String> _extractAllTopicsFromConversations(List<ConversationData> conversations) {
    final topics = <String>{};
    
    for (var conv in conversations) {
      final topic = _extractSingleTopicFromTitle(conv.title);
      if (topic.isNotEmpty && topic.toLowerCase() != 'chatting') {
        topics.add(topic);
      }
    }
    
    return topics.toList();
  }
  
  /// Extract a single topic from a conversation title
  static String _extractSingleTopicFromTitle(String title) {
    // Map of known topic categories and their keywords (same as in _extractTopicFromConversations)
    final topicCategories = {
      'Your Ex': ['ex', 'ex-', 'breakup', 'break up', 'former', 'past relationship', 'old flame', 'previous', 'split', 'divorce', 'separated'],
      'Healing': ['healing', 'heal', 'recovery', 'recover', 'recovering', 'healing journey', 'self-healing', 'emotional healing', 'trauma', 'healing process'],
      'Therapy': ['therapy', 'therapist', 'counseling', 'counselor', 'psychotherapy', 'mental health', 'therapy session', 'therapeutic', 'counseling session'],
      'Self-Care': ['self-care', 'self care', 'selfcare', 'wellness', 'wellbeing', 'self-love', 'self love', 'self improvement', 'self-improvement', 'mental wellness'],
      'Baking': ['baking', 'bake', 'baker', 'cake', 'cookies', 'pastry', 'dessert', 'sweet', 'recipe', 'baking recipe', 'homemade'],
      'Programming': ['code', 'program', 'python', 'javascript', 'java', 'react', 'flutter', 'app', 'software', 'developer', 'coding', 'algorithm', 'function', 'variable', 'debug', 'api', 'html', 'css', 'sql', 'database'],
      'Writing': ['write', 'story', 'essay', 'article', 'blog', 'poem', 'novel', 'character', 'plot', 'narrative', 'creative', 'author', 'book', 'text', 'content'],
      'Learning': ['learn', 'study', 'course', 'tutorial', 'lesson', 'education', 'school', 'university', 'exam', 'test', 'homework', 'assignment', 'research', 'knowledge'],
      'Career': ['work', 'career', 'job', 'interview', 'resume', 'cv', 'professional', 'business', 'company', 'office', 'colleague', 'boss', 'salary', 'promotion'],
      'Health': ['health', 'fitness', 'exercise', 'workout', 'gym', 'diet', 'nutrition', 'weight', 'muscle', 'yoga', 'meditation', 'doctor', 'medical'],
      'Travel': ['travel', 'trip', 'vacation', 'hotel', 'flight', 'airport', 'destination', 'tourist', 'sightseeing', 'adventure', 'journey', 'explore', 'visit'],
      'Cooking': ['cook', 'food', 'recipe', 'kitchen', 'ingredient', 'meal', 'dinner', 'lunch', 'breakfast', 'restaurant', 'cuisine', 'dish'],
      'Art': ['art', 'design', 'drawing', 'painting', 'sketch', 'illustration', 'graphic', 'logo', 'color', 'aesthetic', 'creative', 'artist', 'gallery'],
      'Music': ['music', 'song', 'album', 'artist', 'band', 'concert', 'piano', 'guitar', 'instrument', 'melody', 'lyrics', 'spotify', 'playlist'],
      'Gaming': ['game', 'gaming', 'play', 'player', 'level', 'quest', 'character', 'strategy', 'puzzle', 'multiplayer', 'console', 'pc', 'mobile'],
      'Relationships': ['love', 'relationship', 'dating', 'partner', 'friend', 'family', 'marriage', 'wedding', 'romance', 'crush'],
      'Finance': ['money', 'finance', 'budget', 'investment', 'saving', 'bank', 'credit', 'debit', 'payment', 'salary', 'income', 'expense', 'stock', 'crypto'],
      'Productivity': ['productivity', 'planning', 'organize', 'schedule', 'task', 'goal', 'project', 'deadline', 'time', 'manage', 'efficient', 'optimize', 'system'],
      'Science': ['science', 'research', 'experiment', 'theory', 'hypothesis', 'data', 'analysis', 'study', 'discover', 'physics', 'chemistry', 'biology'],
      'Philosophy': ['philosophy', 'meaning', 'life', 'exist', 'think', 'question', 'truth', 'wisdom', 'mind', 'soul', 'spiritual'],
    };
    
    final titleLower = title.toLowerCase();
    
    // Check for category matches first
    for (final entry in topicCategories.entries) {
      for (final keyword in entry.value) {
        if (titleLower.contains(keyword)) {
          return entry.key;
        }
      }
    }
    
    // Fallback to first meaningful word
    final commonWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'be', 'been',
      'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
      'should', 'may', 'might', 'can', 'how', 'what', 'why', 'when', 'where',
      'me', 'you', 'i', 'my', 'help', 'please', 'thanks', 'need', 'about',
      'chat', 'gpt', 'openai', 'ai', 'assistant', 'conversation', 'new'
    };
    
    final words = titleLower
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((w) => w.length > 3 && !commonWords.contains(w))
        .toList();
    
    if (words.isEmpty) return '';
    
    // Try to map the word to a known category
    final firstWord = words[0];
    for (final entry in topicCategories.entries) {
      if (entry.value.any((keyword) => firstWord.contains(keyword) || keyword.contains(firstWord))) {
        return entry.key;
      }
    }
    
    // Map Serbian/Croatian words to categories
    final serbianWordMap = {
      'zavr': 'Productivity', // zavrena, završiti
      'vreme': 'Productivity', // vreme, time management
      'dokaz': 'Science', // dokaz, proof
      'plan': 'Productivity',
      'zadat': 'Productivity', // zadatak, task
      'projek': 'Productivity', // projekat, project
      'cilj': 'Productivity', // cilj, goal
      'nauka': 'Science', // nauka, science
      'istraž': 'Science', // istraživanje, research
      'posao': 'Career', // posao, work
      'karijer': 'Career', // karijera, career
      'zdravlje': 'Health', // zdravlje, health
      'fitnes': 'Health', // fitnes, fitness
      'putovan': 'Travel', // putovanje, travel
      'kuhanje': 'Cooking', // kuhanje, cooking
      'hrana': 'Cooking', // hrana, food
      'umetnost': 'Art', // umetnost, art
      'muzika': 'Music', // muzika, music
      'igra': 'Gaming', // igra, game
      'ljubav': 'Relationships', // ljubav, love
      'novac': 'Finance', // novac, money
      'učenje': 'Learning', // učenje, learning
      'pisanje': 'Writing', // pisanje, writing
    };
    
    for (final entry in serbianWordMap.entries) {
      if (firstWord.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Return first meaningful word, capitalized
    return firstWord[0].toUpperCase() + firstWord.substring(1);
  }
  
  /// Get random topic from list, avoiding overused topics
  static String _getRandomTopicFromList(
    List<String> topics, 
    Map<String, int> usageCount, {
    String? excludeTopic,
  }) {
    if (topics.isEmpty) return 'Chatting';
    
    // Filter topics that haven't been used 2 times yet
    final availableTopics = topics.where((t) {
      final key = t.toLowerCase();
      if (excludeTopic != null && key == excludeTopic) return false;
      return (usageCount[key] ?? 0) < 2;
    }).toList();
    
    if (availableTopics.isEmpty) {
      // If all topics are used 2 times, just pick any random one
      return topics[DateTime.now().millisecondsSinceEpoch % topics.length];
    }
    
    // Pick random from available topics
    final random = DateTime.now().millisecondsSinceEpoch % availableTopics.length;
    return availableTopics[random];
  }
  
  /// Extract topic from conversation titles for a specific month
  static String _extractTopicFromConversations(List<ConversationData> conversations) {
    if (conversations.isEmpty) return 'Chatting';
    
    // Map of known topic categories and their keywords
    final topicCategories = {
      'Your Ex': ['ex', 'ex-', 'breakup', 'break up', 'former', 'past relationship', 'old flame', 'previous', 'split', 'divorce', 'separated'],
      'Healing': ['healing', 'heal', 'recovery', 'recover', 'recovering', 'healing journey', 'self-healing', 'emotional healing', 'trauma', 'healing process'],
      'Therapy': ['therapy', 'therapist', 'counseling', 'counselor', 'psychotherapy', 'mental health', 'therapy session', 'therapeutic', 'counseling session'],
      'Self-Care': ['self-care', 'self care', 'selfcare', 'wellness', 'wellbeing', 'self-love', 'self love', 'self improvement', 'self-improvement', 'mental wellness'],
      'Baking': ['baking', 'bake', 'baker', 'cake', 'cookies', 'pastry', 'dessert', 'sweet', 'recipe', 'baking recipe', 'homemade'],
      'Programming': ['code', 'program', 'python', 'javascript', 'java', 'react', 'flutter', 'app', 'software', 'developer', 'coding', 'algorithm', 'function', 'variable', 'debug', 'api', 'html', 'css', 'sql', 'database'],
      'Writing': ['write', 'story', 'essay', 'article', 'blog', 'poem', 'novel', 'character', 'plot', 'narrative', 'creative', 'author', 'book', 'text', 'content'],
      'Learning': ['learn', 'study', 'course', 'tutorial', 'lesson', 'education', 'school', 'university', 'exam', 'test', 'homework', 'assignment', 'research', 'knowledge'],
      'Career': ['work', 'career', 'job', 'interview', 'resume', 'cv', 'professional', 'business', 'company', 'office', 'colleague', 'boss', 'salary', 'promotion'],
      'Health': ['health', 'fitness', 'exercise', 'workout', 'gym', 'diet', 'nutrition', 'weight', 'muscle', 'yoga', 'meditation', 'doctor', 'medical'],
      'Travel': ['travel', 'trip', 'vacation', 'hotel', 'flight', 'airport', 'destination', 'tourist', 'sightseeing', 'adventure', 'journey', 'explore', 'visit'],
      'Cooking': ['cook', 'food', 'recipe', 'kitchen', 'ingredient', 'meal', 'dinner', 'lunch', 'breakfast', 'restaurant', 'cuisine', 'dish'],
      'Art': ['art', 'design', 'drawing', 'painting', 'sketch', 'illustration', 'graphic', 'logo', 'color', 'aesthetic', 'creative', 'artist', 'gallery'],
      'Music': ['music', 'song', 'album', 'artist', 'band', 'concert', 'piano', 'guitar', 'instrument', 'melody', 'lyrics', 'spotify', 'playlist'],
      'Gaming': ['game', 'gaming', 'play', 'player', 'level', 'quest', 'character', 'strategy', 'puzzle', 'multiplayer', 'console', 'pc', 'mobile'],
      'Relationships': ['love', 'relationship', 'dating', 'partner', 'friend', 'family', 'marriage', 'wedding', 'romance', 'crush'],
      'Finance': ['money', 'finance', 'budget', 'investment', 'saving', 'bank', 'credit', 'debit', 'payment', 'salary', 'income', 'expense', 'stock', 'crypto'],
      'Productivity': ['productivity', 'planning', 'organize', 'schedule', 'task', 'goal', 'project', 'deadline', 'time', 'manage', 'efficient', 'optimize', 'system'],
      'Science': ['science', 'research', 'experiment', 'theory', 'hypothesis', 'data', 'analysis', 'study', 'discover', 'physics', 'chemistry', 'biology'],
      'Philosophy': ['philosophy', 'meaning', 'life', 'exist', 'think', 'question', 'truth', 'wisdom', 'mind', 'soul', 'spiritual'],
    };
    
    // Count word frequency in titles
    final wordCounts = <String, int>{};
    final commonWords = {
      'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
      'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'be', 'been',
      'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
      'should', 'may', 'might', 'can', 'how', 'what', 'why', 'when', 'where',
      'me', 'you', 'i', 'my', 'help', 'please', 'thanks', 'need', 'about',
      'chat', 'gpt', 'openai', 'ai', 'assistant', 'conversation', 'new'
    };
    
    // First, try to find category matches
    final categoryMatches = <String, int>{};
    
    for (final conv in conversations) {
      final titleLower = conv.title.toLowerCase();
      
      // Check for category matches
      topicCategories.forEach((category, keywords) {
        for (final keyword in keywords) {
          if (titleLower.contains(keyword)) {
            categoryMatches[category] = (categoryMatches[category] ?? 0) + 1;
            break; // Count each category only once per title
          }
        }
      });
      
      // Also count individual words
      final words = conv.title
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(' ')
          .where((w) => w.length > 3 && !commonWords.contains(w));
      
      for (final word in words) {
        wordCounts[word] = (wordCounts[word] ?? 0) + 1;
      }
    }
    
    // Prefer category matches over individual words
    if (categoryMatches.isNotEmpty) {
      String topCategory = 'Chatting';
      int maxCount = 0;
      categoryMatches.forEach((category, count) {
        if (count > maxCount) {
          maxCount = count;
          topCategory = category;
        }
      });
      return topCategory;
    }
    
    // Fallback to most common meaningful word
    if (wordCounts.isEmpty) return 'Chatting';
    
    // Find most common meaningful word
    String topWord = 'Chatting';
    int maxCount = 0;
    wordCounts.forEach((word, count) {
      if (count > maxCount) {
        maxCount = count;
        topWord = word;
      }
    });
    
    // Try to map the word to a known category
    final wordLower = topWord.toLowerCase();
    for (final entry in topicCategories.entries) {
      if (entry.value.any((keyword) => wordLower.contains(keyword) || keyword.contains(wordLower))) {
        return entry.key;
      }
    }
    
    // Map Serbian/Croatian words to categories
    final serbianWordMap = {
      'zavr': 'Productivity', // zavrena, završiti
      'vreme': 'Productivity', // vreme, time management
      'dokaz': 'Science', // dokaz, proof
      'plan': 'Productivity',
      'zadat': 'Productivity', // zadatak, task
      'projek': 'Productivity', // projekat, project
      'cilj': 'Productivity', // cilj, goal
      'nauka': 'Science', // nauka, science
      'istraž': 'Science', // istraživanje, research
      'posao': 'Career', // posao, work
      'karijer': 'Career', // karijera, career
      'zdravlje': 'Health', // zdravlje, health
      'fitnes': 'Health', // fitnes, fitness
      'putovan': 'Travel', // putovanje, travel
      'kuhanje': 'Cooking', // kuhanje, cooking
      'hrana': 'Cooking', // hrana, food
      'umetnost': 'Art', // umetnost, art
      'muzika': 'Music', // muzika, music
      'igra': 'Gaming', // igra, game
      'ljubav': 'Relationships', // ljubav, love
      'novac': 'Finance', // novac, money
      'učenje': 'Learning', // učenje, learning
      'pisanje': 'Writing', // pisanje, writing
    };
    
    for (final entry in serbianWordMap.entries) {
      if (wordLower.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Capitalize and format
    final formatted = topWord[0].toUpperCase() + topWord.substring(1);
    return formatted;
  }
  
  /// Get emoji for topic
  static String _getEmojiForTopic(String topic) {
    final topicLower = topic.toLowerCase();
    
    // Map topics to emojis - viral TikTok topics first
    if (topicLower.contains('your ex') || topicLower.contains('ex') || topicLower.contains('breakup')) return '💔';
    if (topicLower.contains('healing') || topicLower.contains('heal') || topicLower.contains('recovery')) return '🌱';
    if (topicLower.contains('therapy') || topicLower.contains('therapist') || topicLower.contains('counseling')) return '🧘';
    if (topicLower.contains('self-care') || topicLower.contains('self care') || topicLower.contains('selfcare')) return '✨';
    if (topicLower.contains('baking') || topicLower.contains('bake') || topicLower.contains('cake') || topicLower.contains('cookies')) return '🍰';
    
    // Other topics
    if (topicLower.contains('programming') || topicLower.contains('code') || topicLower.contains('program')) return '💻';
    if (topicLower.contains('writing') || topicLower.contains('write') || topicLower.contains('story')) return '✍️';
    if (topicLower.contains('learning') || topicLower.contains('learn') || topicLower.contains('study')) return '📚';
    if (topicLower.contains('career') || topicLower.contains('work') || topicLower.contains('job')) return '💼';
    if (topicLower.contains('health') || topicLower.contains('fitness') || topicLower.contains('exercise')) return '💪';
    if (topicLower.contains('travel') || topicLower.contains('trip') || topicLower.contains('vacation')) return '✈️';
    if (topicLower.contains('cooking') || topicLower.contains('cook') || topicLower.contains('food') || topicLower.contains('recipe')) return '🍳';
    if (topicLower.contains('art') || topicLower.contains('design') || topicLower.contains('drawing')) return '🎨';
    if (topicLower.contains('music') || topicLower.contains('song') || topicLower.contains('album')) return '🎵';
    if (topicLower.contains('gaming') || topicLower.contains('game') || topicLower.contains('play')) return '🎮';
    if (topicLower.contains('relationship') || topicLower.contains('love') || topicLower.contains('dating')) return '💕';
    if (topicLower.contains('finance') || topicLower.contains('money') || topicLower.contains('budget')) return '💰';
    if (topicLower.contains('productivity') || topicLower.contains('planning') || topicLower.contains('organize')) return '📋';
    if (topicLower.contains('science') || topicLower.contains('research') || topicLower.contains('experiment')) return '🔬';
    if (topicLower.contains('philosophy') || topicLower.contains('meaning') || topicLower.contains('wisdom')) return '🤔';
    
    // Try to match partial words
    if (topicLower.contains('zavr') || topicLower.contains('finish') || topicLower.contains('complete')) return '✅';
    if (topicLower.contains('vreme') || topicLower.contains('time') || topicLower.contains('schedule')) return '⏰';
    if (topicLower.contains('dokaz') || topicLower.contains('proof') || topicLower.contains('evidence')) return '📄';
    
    return '💬';
  }
  
  /// Generate sentence for topic with variety
  static String _generateSentenceForTopic(String topic, int month, {bool isConsecutive = false}) {
    final topicLower = topic.toLowerCase().replaceAll('!', '');
    
    // Different sentence templates based on month and topic
    final sentences = [
      'Diving deep into $topicLower this month.',
      'Your main focus was $topicLower.',
      'Spent time exploring $topicLower.',
      'Focused on $topicLower and learning.',
      'Your obsession with $topicLower grew.',
      'Deep conversations about $topicLower.',
      'Exploring $topicLower in new ways.',
      'Your interest in $topicLower peaked.',
    ];
    
    // If consecutive, add "still"
    if (isConsecutive) {
      final stillSentences = [
        'Still diving deep into $topicLower this month.',
        'Still focused on $topicLower.',
        'Still exploring $topicLower.',
        'Your obsession with $topicLower continued.',
        'Still deep conversations about $topicLower.',
        'Still exploring $topicLower in new ways.',
        'Your interest in $topicLower still peaked.',
      ];
      final index = (month + topicLower.hashCode) % stillSentences.length;
      return stillSentences[index];
    }
    
    // Use month as seed for variety
    final index = (month + topicLower.hashCode) % sentences.length;
    return sentences[index];
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
















