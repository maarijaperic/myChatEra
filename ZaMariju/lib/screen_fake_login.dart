import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:gpt_wrapped2/services/chat_parser.dart';
import 'package:gpt_wrapped2/widgets/wrapped_ui.dart';
import 'package:gpt_wrapped2/screen_analyzing_loading.dart';
import 'package:gpt_wrapped2/main.dart' show FreeWrappedNavigator;

/// Fake login screen - uses file import instead of web view
/// Used for App Store review when real login might not pass review
class FakeLoginScreen extends StatefulWidget {
  final Function(List<dynamic>? conversations) onLoginSuccess;

  const FakeLoginScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<FakeLoginScreen> createState() => _FakeLoginScreenState();
}

class _FakeLoginScreenState extends State<FakeLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  String _statusMessage = '';
  File? _selectedFile;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Selecting file...';
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'zip'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _selectedFile = file;
          _statusMessage = 'Reading ${result.files.single.name}...';
        });
        await _importAndContinue();
      } else {
        setState(() {
          _statusMessage = 'No file selected';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error selecting file: $e';
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _extractJsonFromZip(File zipFile) async {
    try {
      setState(() {
        _statusMessage = 'Extracting ZIP file...';
      });

      // Read zip file as bytes
      final zipBytes = await zipFile.readAsBytes();
      
      // Decode zip archive
      final archive = ZipDecoder().decodeBytes(zipBytes);
      
      // Find conversations.json file in the archive
      ArchiveFile? conversationsFile;
      for (final file in archive) {
        if (file.name.toLowerCase().endsWith('conversations.json') || 
            file.name.toLowerCase() == 'conversations.json') {
          conversationsFile = file;
          break;
        }
      }
      
      if (conversationsFile == null) {
        throw Exception('conversations.json not found in ZIP file. Please ensure the ZIP contains conversations.json');
      }
      
      // Extract JSON content
      final jsonString = utf8.decode(conversationsFile.content as List<int>);
      return jsonString;
    } catch (e) {
      throw Exception('Error extracting ZIP file: $e');
    }
  }

  Future<void> _importAndContinue() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a JSON or ZIP file first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Reading file...';
    });

    try {
      String jsonString;
      final fileExtension = _selectedFile!.path.split('.').last.toLowerCase();
      
      // Check if file is ZIP or JSON
      if (fileExtension == 'zip') {
        // Extract JSON from ZIP
        jsonString = await _extractJsonFromZip(_selectedFile!);
      } else {
        // Read JSON file directly
        jsonString = await _selectedFile!.readAsString();
      }
      
      setState(() {
        _statusMessage = 'Parsing conversations...';
      });

      // Parse JSON to validate and get conversation count
      final conversations = await ChatParser.parseJson(jsonString);

      if (conversations.isEmpty) {
        setState(() {
          _statusMessage = 'No conversations found in file';
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No conversations found in the selected file. Please check the file format.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Parse JSON to List<dynamic> for AnalyzingLoadingScreen
      // AnalyzingLoadingScreen will parse it again using DataProcessor
      final conversationsDynamic = json.decode(jsonString) as List<dynamic>;

      setState(() {
        _statusMessage = 'Success! Found ${conversations.length} conversations';
      });

      // Navigate to analyzing screen (same as real login)
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AnalyzingLoadingScreen(
              conversations: conversationsDynamic,
              onAnalysisComplete: (stats, premiumInsights, parsedConversations) {
                print('🔵 FAKE_LOGIN_DEBUG: onAnalysisComplete called');
                print('🔵 FAKE_LOGIN_DEBUG: stats is null = ${stats == null}');
                if (stats != null) {
                  print('🔵 FAKE_LOGIN_DEBUG: stats.mainTopic = ${stats.mainTopic}');
                  print('🔵 FAKE_LOGIN_DEBUG: stats.mostUsedWordCount = ${stats.mostUsedWordCount}');
                  print('🔵 FAKE_LOGIN_DEBUG: stats.totalMessages = ${stats.totalMessages}');
                  print('🔵 FAKE_LOGIN_DEBUG: stats.totalConversations = ${stats.totalConversations}');
                }
                // Navigate to wrapped screens
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => FreeWrappedNavigator(
                      onPremiumTap: () {
                        // Premium handling is done internally by FreeWrappedNavigator._handlePremiumTap
                        // This callback is not actually used, but required by the constructor
                      },
                      stats: stats,
                      premiumInsights: premiumInsights,
                      parsedConversations: parsedConversations,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }

      // Also call the callback for compatibility
      widget.onLoginSuccess(conversationsDynamic);
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error parsing file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  static const _pink = WrappedColors.pinkDeep;
  static const _ink = Color(0xFF1C1C1E);
  static const _muted = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = (screenWidth * 0.08).clamp(24.0, 40.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ink, size: 20),
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: WrappedColors.background),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: kToolbarHeight + screenHeight * 0.01),
                    Text(
                      'IMPORT',
                      style: GoogleFonts.inter(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    HighlightText(
                      'Bring your\n*ChatGPT* chats',
                      accent: WrappedColors.pinkDeep,
                      style: GoogleFonts.inter(
                        fontSize: (screenWidth * 0.085).clamp(30.0, 38.0),
                        fontWeight: FontWeight.w800,
                        color: _ink,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _highlightedText(
                      'Your data comes from the **ChatGPT** app. It only takes a couple of minutes.',
                      baseStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: _muted,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SectionCard(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      child: Column(
                        children: [
                          _buildInstructionStep(1, 'Open the **ChatGPT** app and go to **Settings**'),
                          _buildInstructionStep(2, 'Tap **Data Controls**, then **Export Data**'),
                          _buildInstructionStep(3, 'Open the **email** from ChatGPT and download the **ZIP file**'),
                          _buildInstructionStep(4, 'Come back here and **upload the file**', isLast: true),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (_isLoading && _statusMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Center(
                          child: Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 14, color: _muted, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    WrappedPillButton(
                      label: 'Upload ZIP file',
                      icon: Icons.upload_rounded,
                      loading: _isLoading,
                      onTap: _pickFile,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'You can also upload conversations.json',
                        style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFFAEAEB2)),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Renders text where **marked** parts are highlighted in the accent color.
  Widget _highlightedText(String text, {required TextStyle baseStyle}) {
    final parts = text.split('**');
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd ? const TextStyle(color: _pink, fontWeight: FontWeight.w700) : null,
            ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int number, String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: WrappedColors.pink.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.inter(
                  color: WrappedColors.pinkDeep,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _highlightedText(
                text,
                baseStyle: GoogleFonts.inter(
                  fontSize: 17,
                  color: _ink,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
