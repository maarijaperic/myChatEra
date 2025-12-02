import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:gpt_wrapped2/services/chat_parser.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
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
          _statusMessage = 'File selected: ${result.files.single.name}';
          _isLoading = false;
        });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F21)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Import Your Chat',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F1F21),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth * 0.08).clamp(24.0, 40.0),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - kToolbarHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instructions Card
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F8), // Light pink background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFF006E).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: const Color(0xFFFF006E),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'How to Import',
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF000000), // Pure black for better contrast
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildInstructionStep('1', 'Go to ChatGPT Settings'),
                              const SizedBox(height: 16),
                              _buildInstructionStep('2', 'Navigate to "Data Controls"'),
                              const SizedBox(height: 16),
                              _buildInstructionStep('3', 'Click "Export Data"'),
                              const SizedBox(height: 16),
                              _buildInstructionStep('4', 'Download the conversations.json file (or ZIP archive)'),
                              const SizedBox(height: 16),
                              _buildInstructionStep('5', 'Select the file below to continue'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // File Picker Button
                      SizedBox(
                        width: double.infinity,
                        height: (screenHeight * 0.07).clamp(56.0, 70.0),
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : () async {
                            await _pickFile();
                            if (_selectedFile != null && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('File selected: ${_selectedFile!.path.split(Platform.pathSeparator).last}'),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            _selectedFile != null ? Icons.check_circle : Icons.upload_file,
                            color: Colors.white,
                            size: 22,
                          ),
                          label: Text(
                            _selectedFile != null 
                                ? 'File Selected: ${_selectedFile!.path.split(Platform.pathSeparator).last}'
                                : 'Select File',
                            style: GoogleFonts.inter(
                              fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1F1F21),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                (screenWidth * 0.04).clamp(16.0, 24.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: (screenHeight * 0.02).clamp(16.0, 20.0),
                            ),
                          ),
                        ),
                      ),

                      if (_selectedFile != null) ...[
                        const SizedBox(height: 24),
                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: (screenHeight * 0.07).clamp(56.0, 70.0),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _importAndContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF006E),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  (screenWidth * 0.04).clamp(16.0, 24.0),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: (screenHeight * 0.02).clamp(16.0, 20.0),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Continue',
                                    style: GoogleFonts.inter(
                                      fontSize: (screenWidth * 0.045).clamp(16.0, 20.0),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                          ),
                        ),
                      ],

                      if (_statusMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simple number with circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFFF006E).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF006E),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: const Color(0xFFFF006E),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF000000), // Pure black for better contrast
              fontWeight: FontWeight.w600, // Slightly bolder
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}




