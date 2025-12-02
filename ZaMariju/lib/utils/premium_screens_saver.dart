import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:saver_gallery/saver_gallery.dart' as saver;
import 'package:path_provider/path_provider.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:gpt_wrapped2/screen_mbti_personality.dart';
import 'package:gpt_wrapped2/screen_type_ab_personality.dart';
import 'package:gpt_wrapped2/screen_red_green_flags.dart';
import 'package:gpt_wrapped2/screen_guess_zodiac.dart';
import 'package:gpt_wrapped2/screen_song_title.dart';
import 'package:gpt_wrapped2/screen_introvert_extrovert.dart';
import 'package:gpt_wrapped2/screen_advice_most_asked.dart';
import 'package:gpt_wrapped2/screen_movie_title.dart';
import 'package:gpt_wrapped2/screen_roast_me.dart';
import 'package:gpt_wrapped2/screen_love_language.dart';
import 'package:gpt_wrapped2/screen_past_life_persona.dart';

class PremiumScreensSaver {
  /// Save all premium screens as images to gallery
  static Future<bool> saveAllPremiumScreens({
    required BuildContext context,
    required PremiumInsights insights,
    List<ConversationData>? parsedConversations,
  }) async {
    try {
      final savedImages = <String>[];
      
      // List of all premium screens with their names
      final screens = [
        _ScreenInfo(
          name: 'MBTI Personality',
          widget: MBTIPersonalityScreen(
            question: 'What is your MBTI personality type according to AI?',
            mbtiType: insights.mbtiType,
            mbtiEmoji: insights.mbtiEmoji,
            personalityName: insights.personalityName,
            explanation: insights.mbtiExplanation,
            subtitle: 'Your personality is unique, like a work of art 🎨',
          ),
        ),
        _ScreenInfo(
          name: 'Type A/B Personality',
          widget: TypeABPersonalityScreen(
            question: 'Are you Type A or Type B according to AI?',
            personalityType: insights.personalityType,
            typeEmoji: _getTypeEmoji(insights.personalityType),
            typeAPercentage: insights.typeAPercentage,
            typeBPercentage: insights.typeBPercentage,
            explanation: insights.typeExplanation,
            subtitle: _getPersonalitySubtitle(insights.personalityType),
          ),
        ),
        _ScreenInfo(
          name: 'Red & Green Flags',
          widget: RedGreenFlagsScreen(
            question: 'What are your red and green flags according to AI?',
            greenFlagTitle: 'Green Flags 🟢',
            redFlagTitle: 'Red Flags 🔴',
            greenFlags: insights.greenFlags,
            redFlags: insights.redFlags,
            subtitle: 'Self-love also includes recognizing our areas for improvement 💚❤️',
          ),
        ),
        _ScreenInfo(
          name: 'Zodiac Sign',
          widget: GuessZodiacScreen(
            question: 'What is your zodiac sign according to AI?',
            zodiacSign: insights.zodiacSign,
            zodiacEmoji: insights.zodiacEmoji,
            zodiacName: insights.zodiacName,
            explanation: insights.zodiacExplanation,
            subtitle: 'The stars don\'t lie... and neither does AI! ⭐',
          ),
        ),
        _ScreenInfo(
          name: 'Song Title',
          widget: SongTitleScreen(
            question: 'What song title represents your life according to AI?',
            songTitle: insights.songTitle,
            artist: insights.songArtist,
            releaseYear: insights.songYear,
            explanation: insights.songExplanation,
            subtitle: 'Your life has a soundtrack 🎵',
          ),
        ),
        _ScreenInfo(
          name: 'Introvert vs Extrovert',
          widget: IntrovertExtrovertScreen(
            question: 'Are you an introvert or extrovert according to AI?',
            personalityType: insights.introExtroType,
            introvertPercentage: insights.introvertPercentage,
            extrovertPercentage: insights.extrovertPercentage,
            explanation: insights.introExtroExplanation,
            subtitle: _getIntroExtroSubtitle(insights.introExtroType),
          ),
        ),
        _ScreenInfo(
          name: 'Most Asked Advice',
          widget: AdviceMostAskedScreen(
            question: 'What advice do you ask for most?',
            mostAskedAdvice: insights.mostAskedAdvice,
            adviceCategory: insights.adviceCategory,
            adviceEmoji: insights.adviceEmoji,
            explanation: insights.adviceExplanation,
            subtitle: 'Your questions reveal your priorities 💭',
          ),
        ),
        _ScreenInfo(
          name: 'Movie Title',
          widget: MovieTitleScreen(
            question: 'What movie title represents your life according to AI?',
            movieTitle: insights.movieTitle,
            releaseYear: insights.movieYear,
            explanation: insights.movieExplanation,
            subtitle: 'Your life is a blockbuster 🎬',
          ),
        ),
        _ScreenInfo(
          name: 'AI Roast',
          widget: RoastMeScreen(
            question: 'What would AI roast you about?',
            roastText: insights.roastText,
            subtitle: 'AI knows you better than you think 😂',
          ),
        ),
        _ScreenInfo(
          name: 'Love Language',
          widget: LoveLanguageScreen(
            question: 'What is your love language according to AI?',
            loveLanguage: insights.loveLanguage,
            languageEmoji: insights.languageEmoji,
            loveLanguagePercentages: _getLoveLanguageDistribution(insights.loveLanguage),
            explanation: insights.loveLanguageExplanation,
            subtitle: 'Love speaks in many languages 💕',
          ),
        ),
        _ScreenInfo(
          name: 'Past Life Persona',
          widget: PastLifePersonaScreen(
            question: 'Who were you in a past life according to AI?',
            personaTitle: insights.personaTitle,
            personaEmoji: insights.personaEmoji,
            era: insights.era,
            description: insights.personaDescription,
            subtitle: 'Your past lives reveal your essence ✨',
          ),
        ),
      ];

      print('🔵 SCREENS_SAVER: Starting to save ${screens.length} screens');
      
      // Show initial progress dialog
      if (context.mounted) {
        // Don't try to pop - there might not be a dialog yet
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text('Saving screen 1 of ${screens.length}...'),
              ],
            ),
          ),
        );
      }

      // Capture each screen
      for (int i = 0; i < screens.length; i++) {
        final screenInfo = screens[i];
        print('🔵 SCREENS_SAVER: Capturing screen ${i + 1}/${screens.length}: ${screenInfo.name}');
        
        // Update progress
        if (context.mounted) {
          // Try to pop existing dialog, but don't fail if there isn't one
          try {
            Navigator.of(context).pop();
          } catch (e) {
            print('🔵 SCREENS_SAVER: No dialog to pop: $e');
          }
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Saving screen ${i + 1} of ${screens.length}...'),
                ],
              ),
            ),
          );
        }
        
        try {
          final imagePath = await _captureScreen(
            context: context,
            screen: screenInfo.widget,
            screenName: screenInfo.name,
            index: i + 1,
            total: screens.length,
          );
          
          if (imagePath != null) {
            savedImages.add(imagePath);
            print('🔵 SCREENS_SAVER: Successfully captured ${screenInfo.name}');
          } else {
            print('🔵 SCREENS_SAVER: Failed to capture ${screenInfo.name}');
          }
        } catch (e, stackTrace) {
          print('🔵 SCREENS_SAVER: Error capturing ${screenInfo.name}: $e');
          print('🔵 SCREENS_SAVER: Stack trace: $stackTrace');
        }
      }
      
      // Close progress dialog
      if (context.mounted) {
        try {
          Navigator.of(context).pop();
        } catch (e) {
          print('🔵 SCREENS_SAVER: Error closing dialog: $e');
        }
      }

      print('🔵 SCREENS_SAVER: Captured ${savedImages.length} images, saving to gallery...');

      // Save all images to gallery
      if (savedImages.isNotEmpty) {
        int savedCount = 0;
        int failedCount = 0;
        List<String> errorMessages = [];
        
        // Show progress dialog for saving
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Saving images to gallery...'),
                ],
              ),
            ),
          );
        }
        
        for (int i = 0; i < savedImages.length; i++) {
          final imagePath = savedImages[i];
          try {
            final file = File(imagePath);
            if (await file.exists()) {
              final bytes = await file.readAsBytes();
              final fileName = imagePath.split(Platform.pathSeparator).last;
              print('🔵 SCREENS_SAVER: Saving ${i + 1}/${savedImages.length}: $fileName to gallery...');
              
              // Update progress dialog
              if (context.mounted) {
                Navigator.of(context).pop(); // Close previous dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('Saving image ${i + 1} of ${savedImages.length}...'),
                      ],
                    ),
                  ),
                );
              }
              
              try {
                print('🔵 SCREENS_SAVER: Attempting to save $fileName (${bytes.length} bytes)...');
                
                // saver_gallery API: saveImage(Uint8List bytes, {required String fileName, String? androidRelativePath, bool skipIfExists = false})
                final result = await saver.SaverGallery.saveImage(
                  bytes,
                  fileName: fileName,
                  androidRelativePath: 'Pictures/GPT_Wrapped',
                  skipIfExists: false,
                );
                
                print('🔵 SCREENS_SAVER: saveImage result for $fileName: $result (type: ${result.runtimeType})');
                
                // Check if result indicates success
                // saver_gallery returns SaveResult enum
                final resultStr = result.toString();
                print('🔵 SCREENS_SAVER: Result string: $resultStr');
                
                // Check if SaveResult indicates success
                // SaveResult enum - check string representation
                // Common values: SaveResult.success, SaveResult.failed, etc.
                final lowerResult = resultStr.toLowerCase();
                final isSuccess = lowerResult.contains('success') || 
                                (lowerResult.contains('saveresult') && lowerResult.contains('success')) ||
                                (!lowerResult.contains('fail') && !lowerResult.contains('error'));
                
                if (isSuccess) {
                  savedCount++;
                  print('🔵 SCREENS_SAVER: ✓ Successfully saved to gallery: $fileName');
                } else {
                  failedCount++;
                  final errorMsg = 'Failed to save $fileName (result: $result, type: ${result.runtimeType})';
                  errorMessages.add(errorMsg);
                  print('🔵 SCREENS_SAVER: ✗ $errorMsg');
                }
              } catch (saveError, saveStackTrace) {
                failedCount++;
                final errorMsg = 'Exception saving $fileName: $saveError';
                errorMessages.add(errorMsg);
                print('🔵 SCREENS_SAVER: ✗ $errorMsg');
                print('🔵 SCREENS_SAVER: Save stack trace: $saveStackTrace');
              }
            } else {
              failedCount++;
              final errorMsg = 'File does not exist: $imagePath';
              errorMessages.add(errorMsg);
              print('🔵 SCREENS_SAVER: ✗ $errorMsg');
            }
          } catch (e, stackTrace) {
            failedCount++;
            final errorMsg = 'Unexpected error with $imagePath: $e';
            errorMessages.add(errorMsg);
            print('🔵 SCREENS_SAVER: ✗ $errorMsg');
            print('🔵 SCREENS_SAVER: Stack trace: $stackTrace');
          }
        }
        
        // Close progress dialog
        if (context.mounted) {
          try {
            Navigator.of(context).pop();
          } catch (e) {
            print('🔵 SCREENS_SAVER: Error closing dialog: $e');
          }
        }
        
        print('🔵 SCREENS_SAVER: Save summary - Saved: $savedCount, Failed: $failedCount, Total: ${savedImages.length}');
        if (errorMessages.isNotEmpty) {
          print('🔵 SCREENS_SAVER: Errors:');
          for (final error in errorMessages) {
            print('🔵 SCREENS_SAVER:   - $error');
          }
        }
        
        // Return true if at least one image was saved
        return savedCount > 0;
      }
      
      print('🔵 SCREENS_SAVER: No images to save');
      return false;
    } catch (e) {
      print('Error saving premium screens: $e');
      return false;
    }
  }

  static Future<String?> _captureScreen({
    required BuildContext context,
    required Widget screen,
    required String screenName,
    required int index,
    required int total,
  }) async {
    print('🔵 CAPTURE_SCREEN: Starting capture for $screenName');
    try {
      // Create a GlobalKey for RepaintBoundary
      final key = GlobalKey();
      
      // Get screen size from context
      final screenSize = MediaQuery.of(context).size;
      
      // Build the screen widget wrapped in RepaintBoundary
      final screenWidget = RepaintBoundary(
        key: key,
        child: MaterialApp(
          home: MediaQuery(
            data: MediaQuery.of(context).copyWith(size: screenSize),
            child: Scaffold(
              body: screen,
            ),
          ),
          debugShowCheckedModeBanner: false,
        ),
      );

      // Use Overlay to render widget offscreen without affecting navigation
      print('🔵 CAPTURE_SCREEN: Rendering widget offscreen using Overlay for $screenName');
      
      // Get the overlay from context
      final overlay = Overlay.of(context);
      OverlayEntry? overlayEntry;
      
      try {
        // Create overlay entry
        overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            left: -10000, // Position offscreen
            top: -10000,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.0, // Make invisible
                child: screenWidget,
              ),
            ),
          ),
        );
        
        // Insert overlay entry
        overlay.insert(overlayEntry);
        
        // Wait for frame to render
        print('🔵 CAPTURE_SCREEN: Waiting for render...');
        await Future.delayed(const Duration(milliseconds: 2000));
        
        // Wait for next frame to ensure rendering is complete
        await WidgetsBinding.instance.endOfFrame;

        // Get render boundary
        final RenderRepaintBoundary? renderBoundary = 
            key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        
        String? imagePath;
        
        if (renderBoundary != null) {
          print('🔵 CAPTURE_SCREEN: Render boundary found, capturing image...');
          // Capture image
          final image = await renderBoundary.toImage(pixelRatio: 3.0);
          final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
          
          if (byteData != null) {
            final bytes = byteData.buffer.asUint8List();

            // Save to temporary file
            final directory = await getTemporaryDirectory();
            final timestamp = DateTime.now().millisecondsSinceEpoch;
            imagePath = '${directory.path}/GPT_Wrapped_${screenName.replaceAll(' ', '_')}_$timestamp.png';
            
            final file = File(imagePath);
            await file.writeAsBytes(bytes);
            print('🔵 CAPTURE_SCREEN: Image saved to $imagePath');
          } else {
            print('🔵 CAPTURE_SCREEN: Failed to get byte data');
          }
        } else {
          print('🔵 CAPTURE_SCREEN: Render boundary is null');
        }
        
        return imagePath;
      } finally {
        // Always remove overlay entry
        if (overlayEntry != null) {
          print('🔵 CAPTURE_SCREEN: Removing overlay entry');
          overlayEntry.remove();
        }
      }
    } catch (e, stackTrace) {
      print('🔵 CAPTURE_SCREEN: Error capturing screen $screenName: $e');
      print('🔵 CAPTURE_SCREEN: Stack trace: $stackTrace');
      return null;
    }
  }

  static String _getTypeEmoji(String type) {
    switch (type.toUpperCase()) {
      case 'TYPE A':
        return '⚡';
      case 'TYPE B':
        return '🌊';
      default:
        return '🌟';
    }
  }

  static String _getPersonalitySubtitle(String type) {
    switch (type.toUpperCase()) {
      case 'TYPE A':
        return 'You sprint through life with unstoppable energy ⚡';
      case 'TYPE B':
        return 'You flow through life with chill confidence 🌈';
      default:
        return 'Knowing yourself is the first step to growth 🌟';
    }
  }

  static String _getIntroExtroSubtitle(String type) {
    switch (type.toUpperCase()) {
      case 'INTROVERT':
        return 'Your quiet power lights up deep conversations 🌙';
      case 'EXTROVERT':
        return 'Your social battery charges the room 🔋';
      default:
        return 'The perfect balance between introspection and sociability 🧠💬';
    }
  }

  static Map<String, int> _getLoveLanguageDistribution(String primary) {
    final defaultOrder = [
      'Words of Affirmation',
      'Quality Time',
      'Acts of Service',
      'Physical Touch',
      'Receiving Gifts',
    ];

    final normalizedPrimary = primary.trim().toLowerCase();
    final primaryKey = defaultOrder.firstWhere(
      (lang) => lang.toLowerCase() == normalizedPrimary,
      orElse: () => defaultOrder.first,
    );

    final distribution = <String, int>{};
    for (final lang in defaultOrder) {
      distribution[lang] = lang == primaryKey ? 40 : 15;
    }

    final total = distribution.values.reduce((a, b) => a + b);
    if (total != 100) {
      final diff = 100 - total;
      distribution[primaryKey] = (distribution[primaryKey]! + diff).clamp(0, 100);
    }

    return distribution;
  }
}

class _ScreenInfo {
  final String name;
  final Widget widget;

  _ScreenInfo({
    required this.name,
    required this.widget,
  });
}
