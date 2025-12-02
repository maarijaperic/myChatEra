import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:gpt_wrapped2/screen_analyzing_loading.dart';
import 'package:gpt_wrapped2/main.dart' show FreeWrappedNavigator;
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  final Function(List<dynamic>? conversations) onLoginSuccess;
  final bool autoShowWebView;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    this.autoShowWebView = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showWebView = false;
  InAppWebViewController? _webViewController;
  String? _accessToken;
  List<dynamic>? _conversations; // Stored for potential future use
  String _status = '';
  Timer? _loadTimeoutTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Automatically show web view if requested
    if (widget.autoShowWebView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showWebView = true;
          _status = 'Opening ChatGPT login...';
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _loadTimeoutTimer?.cancel();
    super.dispose();
  }

  Future<bool> _checkNetworkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleLogin() async {
    // Check if email or password is empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Check network connectivity
    setState(() {
      _isLoading = true;
      _status = 'Checking network connection...';
    });

    final hasNetwork = await _checkNetworkConnection();
    
    if (!hasNetwork) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your network and try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // Don't store password - use WebView for authentication
    setState(() {
      _showWebView = true;
      _status = 'Opening ChatGPT login...';
      _isLoading = true;
    });
  }

  Future<void> _checkLoginStatus() async {
    if (_webViewController == null) return;

    const js = '''
      (async function() {
        try {
          const r = await fetch('/api/auth/session', { credentials: 'include' });
          if (r.ok) {
            const data = await r.json();
            const token = data && data.accessToken ? data.accessToken : '';
            if (token) {
              window.flutter_inappwebview.callHandler('onToken', token);
              return 'LOGGED_IN';
            }
          }
          return 'NOT_LOGGED_IN';
        } catch (e) {
          return 'ERROR';
        }
      })();
    ''';

    final result = await _webViewController!.evaluateJavascript(source: js);
    if (result == 'LOGGED_IN') {
      await _fetchConversations();
    }
  }

  Future<void> _fetchConversations() async {
    if (_webViewController == null || _accessToken == null) return;

    if (!mounted) return;
    setState(() => _status = 'Fetching your conversations...');

    const js = '''
      (async function() {
        try {
          const sessionResp = await fetch('/api/auth/session', { credentials: 'include' });
          if (!sessionResp.ok) {
            window.flutter_inappwebview.callHandler('onFetchError', 'SESSION_ERROR');
            return 'SESSION_ERROR';
          }
          
          const session = await sessionResp.json();
          const token = session && session.accessToken ? session.accessToken : null;
          if (!token) {
            window.flutter_inappwebview.callHandler('onFetchError', 'NO_TOKEN');
            return 'NO_TOKEN';
          }
          
          const resp = await fetch('/backend-api/conversations?offset=0&limit=50&order=updated', {
            method: 'GET',
            headers: {
              'Authorization': 'Bearer ' + token,
              'Accept': 'application/json'
            },
            credentials: 'include'
          });
          
          if (!resp.ok) {
            window.flutter_inappwebview.callHandler('onFetchError', 'FETCH_ERROR');
            return 'FETCH_ERROR';
          }
          
          const json = await resp.json();
          const items = (json && json.items) ? json.items : [];
          
          window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: items, done: true }));
          return 'OK';
        } catch (e) {
          const errorMsg = e && e.message ? e.message : String(e);
          window.flutter_inappwebview.callHandler('onFetchError', 'ERROR:' + errorMsg);
          return 'ERROR:' + errorMsg;
        }
      })();
    ''';

    await _webViewController!.evaluateJavascript(source: js);
  }

  Future<void> _fetchFullConversations(List<dynamic> conversationList) async {
    if (_webViewController == null || !mounted) return;

    final fullConversations = <Map<String, dynamic>>[];
    final totalCount = conversationList.length;
    const batchSize = 4; // Fetch 4 conversations in parallel

    // Process conversations in batches
    for (int i = 0; i < conversationList.length; i += batchSize) {
      if (!mounted) return;

      // Get batch of conversations
      final batch = conversationList.skip(i).take(batchSize).toList();
      final batchFutures = <Future<Map<String, dynamic>?>>[];

      // Start fetching all conversations in batch in parallel
      for (var conv in batch) {
        if (conv is! Map<String, dynamic>) {
          batchFutures.add(Future.value(conv));
          continue;
        }
        
        final id = (conv['id'] as String?) ?? '';
        if (id.isEmpty) {
          batchFutures.add(Future.value(conv));
          continue;
        }

        // Add fetch future to batch
        batchFutures.add(_fetchSingleConversation(id).then((fullConv) {
          return fullConv ?? conv; // Return full conversation or fallback to metadata
        }).catchError((e) {
          print('Error fetching conversation $id: $e');
          return conv; // Return metadata on error
        }));
      }

      // Wait for all conversations in batch to complete
      final batchResults = await Future.wait(batchFutures);
      // Filter out null values and add to fullConversations
      for (final result in batchResults) {
        if (result != null) {
          fullConversations.add(result);
        }
      }

      // Update status with percentage
      if (mounted) {
        final progress = (fullConversations.length / totalCount * 100).round();
        setState(() {
          _status = 'Loading messages... $progress%';
        });
      }

      // Small delay between batches to avoid rate limiting
      if (i + batchSize < conversationList.length) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }

    // Store conversations first
    _conversations = fullConversations;
    
    // Debug: Log conversation details
    print('🔵 LOGIN_DEBUG: Fetched ${fullConversations.length} conversations');
    int conversationsWithMessages = 0;
    for (int i = 0; i < fullConversations.length; i++) {
      final conv = fullConversations[i];
      // Check if conversation has messages
      final hasMapping = conv.containsKey('mapping') && conv['mapping'] != null;
      final hasMessages = conv.containsKey('messages') && conv['messages'] is List && (conv['messages'] as List).isNotEmpty;
      if (hasMapping || hasMessages) {
        conversationsWithMessages++;
      }
      if (i < 3) { // Log first 3 conversations
        print('🔵 LOGIN_DEBUG: Conversation $i: id=${conv['id']}, hasMapping=$hasMapping, hasMessages=$hasMessages');
      }
    }
    print('🔵 LOGIN_DEBUG: Conversations with messages: $conversationsWithMessages out of ${fullConversations.length}');
    
    if (mounted) {
      setState(() {
        _status = 'Loading complete ✓';
        _isLoading = false;
      });
    }

    // Auto-complete login after fetching
    // Add a small delay to ensure all conversations are fully loaded
    Future.delayed(const Duration(milliseconds: 500), () {
      print('🔵 Future.delayed callback - mounted: $mounted');
      print('🔵 LOGIN_DEBUG: About to call _completeLogin with ${_conversations?.length ?? 0} conversations');
      if (!mounted) {
        print('⚠️ Widget not mounted, calling _completeLogin anyway');
        _completeLogin();
        return;
      }
      print('🔵 Calling _completeLogin');
      _completeLogin();
    });
  }

  Future<Map<String, dynamic>?> _fetchSingleConversation(String conversationId) async {
    if (_webViewController == null) return null;

    final completer = Completer<Map<String, dynamic>?>();
    var hasCompleted = false;
    Map<String, dynamic>? result;

    final js = '''
      (async function() {
        try {
          const sessionResp = await fetch('/api/auth/session', { credentials: 'include' });
          if (!sessionResp.ok) return null;
          const session = await sessionResp.json();
          const token = session && session.accessToken ? session.accessToken : null;
          if (!token) return null;

          const url = '/backend-api/conversation/' + encodeURIComponent('$conversationId');
          const resp = await fetch(url, {
            method: 'GET',
            headers: {
              'Authorization': 'Bearer ' + token,
              'Accept': 'application/json',
              'Content-Type': 'application/json'
            },
            credentials: 'include'
          });
          
          if (!resp.ok) return null;
          const raw = await resp.json();

          const toText = (content) => {
            if (!content) return '';
            if (Array.isArray(content.parts)) {
              return content.parts
                .map((part) => {
                  if (typeof part === 'string') return part;
                  if (part && typeof part.text === 'string') return part.text;
                  return '';
                })
                .filter(Boolean)
                .join('\\n')
                .trim();
            }
            if (typeof content.text === 'string') {
              return content.text.trim();
            }
            return '';
          };

          const toEpochSeconds = (value) => {
            if (typeof value === 'number') return value;
            if (typeof value === 'string') {
              const parsed = Date.parse(value);
              if (!Number.isNaN(parsed)) {
                return Math.floor(parsed / 1000);
              }
            }
            return 0;
          };

          const simplifyMessages = (mapping) => {
            const collected = [];
            const nodes = Object.values(mapping || {});
            for (const node of nodes) {
              if (!node || !node.message) continue;
              const msg = node.message;
              const role = msg.author && msg.author.role ? msg.author.role : '';
              if (role !== 'user' && role !== 'assistant') continue;

              const text = toText(msg.content);
              if (!text) continue;

              collected.push({
                id: msg.id || node.id || '',
                role,
                content: text,
                create_time: msg.create_time || node.create_time || null,
              });
            }

            collected.sort((a, b) => {
              const aTime = toEpochSeconds(a.create_time);
              const bTime = toEpochSeconds(b.create_time);
              return aTime - bTime;
            });

            const HARD_LIMIT = 250;
            if (collected.length > HARD_LIMIT) {
              const step = collected.length / HARD_LIMIT;
              const reduced = [];
              for (let i = 0; i < HARD_LIMIT; i++) {
                const idx = Math.floor(i * step);
                if (idx < collected.length) {
                  reduced.push(collected[idx]);
                }
              }
              return reduced;
            }

            return collected;
          };

          const simplified = {
            id: raw.id || raw.conversation_id || '$conversationId',
            title: raw.title || 'Untitled',
            create_time: raw.create_time || raw.timestamp || null,
            update_time: raw.update_time || raw.last_modified_at || raw.create_time || null,
            messages: simplifyMessages(raw.mapping),
          };

          window.flutter_inappwebview.callHandler('onConversationData', JSON.stringify(simplified));
          return simplified;
        } catch (e) {
          return null;
        }
      })();
    ''';

    // Set up one-time handler
    _webViewController!.removeJavaScriptHandler(handlerName: 'onConversationData');
    _webViewController!.addJavaScriptHandler(
      handlerName: 'onConversationData',
      callback: (args) {
        if (hasCompleted) {
          return {'ok': true};
        }
        hasCompleted = true;
        if (args.isNotEmpty && args.first is String) {
          try {
            result = jsonDecode(args.first as String) as Map<String, dynamic>;
            if (!completer.isCompleted) {
              completer.complete(result);
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          }
        } else {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        }
        _webViewController!.removeJavaScriptHandler(handlerName: 'onConversationData');
        return {'ok': true};
      },
    );

    await _webViewController!.evaluateJavascript(source: js);
    
    try {
      return await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => null,
      );
    } catch (e) {
      return null;
    } finally {
      try {
        _webViewController?.removeJavaScriptHandler(handlerName: 'onConversationData');
      } catch (e) {
        // Ignore errors when removing handler
      }
    }
  }

  void _completeLogin() {
    print('🔵 _completeLogin called with ${_conversations?.length ?? 0} conversations');
    // Clear password from memory (never stored)
    _passwordController.clear();
    
    // Debug: Verify conversations before passing
    if (_conversations != null) {
      print('🔵 LOGIN_DEBUG: Verifying conversations before passing to AnalyzingLoadingScreen...');
      int conversationsWithData = 0;
      for (int i = 0; i < _conversations!.length; i++) {
        final conv = _conversations![i];
        final hasMapping = conv.containsKey('mapping') && conv['mapping'] != null;
        final hasMessages = conv.containsKey('messages') && conv['messages'] is List && (conv['messages'] as List).isNotEmpty;
        if (hasMapping || hasMessages) {
          conversationsWithData++;
        }
      }
      print('🔵 LOGIN_DEBUG: Conversations with data: $conversationsWithData out of ${_conversations!.length}');
    }
    
    if (!mounted) {
      print('⚠️ LoginScreen not mounted, calling callback anyway');
      widget.onLoginSuccess(_conversations);
      return;
    }
    
    // Navigate directly from LoginScreen context - this is more reliable
    print('🔵 Navigating directly from LoginScreen to AnalyzingLoadingScreen');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AnalyzingLoadingScreen(
          onAnalysisComplete: (stats, premiumInsights, parsedConversations) {
            // Store analysis results in closure variables to pass to navigator
            final parsedCount = parsedConversations?.length ?? 0;
            print('🔵 onAnalysisComplete - stats: ${stats != null}, premiumInsights: ${premiumInsights != null}, parsedConversations: $parsedCount');
            
            // CRITICAL: Log conversation details for debugging
            if (parsedConversations != null) {
              int conversationsWithMessages = 0;
              for (int i = 0; i < parsedConversations.length; i++) {
                final conv = parsedConversations[i];
                if (conv.messages.isNotEmpty) {
                  conversationsWithMessages++;
                }
                if (i < 3) {
                  print('🔵 LOGIN_DEBUG: Conversation $i: id=${conv.id}, title=${conv.title}, messages=${conv.messages.length}');
                }
              }
              print('🔵 LOGIN_DEBUG: Conversations with messages: $conversationsWithMessages out of ${parsedConversations.length}');
            }
            
            // Navigate directly to FreeWrappedNavigator (Daily Dose screen) - skipping IntroScreen
            print('🔵 onAnalysisComplete - navigating directly to FreeWrappedNavigator');
            print('🔵 LOGIN_DEBUG: parsedConversations to pass: ${parsedConversations?.length ?? 0}');
            
            // CRITICAL: Ensure we have conversations with messages before passing
            List<ConversationData>? conversationsToPass = parsedConversations;
            if (conversationsToPass != null && conversationsToPass.isNotEmpty) {
              // Filter to only conversations with messages
              final filtered = conversationsToPass.where((conv) => conv.messages.isNotEmpty).toList();
              
              if (filtered.isNotEmpty) {
                conversationsToPass = filtered;
                print('🔵 LOGIN_DEBUG: Filtered conversations with messages: ${filtered.length}');
              } else {
                print('🔵 LOGIN_DEBUG: WARNING - No conversations with messages after filtering!');
                // Keep original conversations - maybe they'll work
                print('🔵 LOGIN_DEBUG: Keeping original ${conversationsToPass.length} conversations');
              }
            }
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  print('🔵 LOGIN_DEBUG: Building FreeWrappedNavigator with ${conversationsToPass?.length ?? 0} conversations');
                  
                  if (conversationsToPass == null || conversationsToPass.isEmpty) {
                    print('🔵 LOGIN_DEBUG: ERROR - No conversations to pass to FreeWrappedNavigator!');
                  }
                  
                  // Create a proper onPremiumTap callback that uses the parsed conversations
                  return FreeWrappedNavigator(
                    onPremiumTap: () {
                      // This callback will be replaced by _handlePremiumTap in FreeWrappedNavigator
                      // But we need to ensure conversations are available
                      print('🔵 LOGIN_DEBUG: onPremiumTap called (this should not be used)');
                    },
                    stats: stats,
                    premiumInsights: premiumInsights,
                    parsedConversations: conversationsToPass, // This is List<ConversationData>?
                  );
                },
              ),
            );
          },
          conversations: _conversations, // This is List<dynamic>? from web view
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenWidth > 600;

    // Responsive padding
    final horizontalPadding = (screenWidth * 0.1).clamp(24.0, 48.0);

    if (_showWebView) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFDF5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFDF5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
            onPressed: () {
              // Navigate back to WelcomeScreen (which has ToS and Privacy Policy)
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Sign in to AI',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: (screenWidth * 0.042).clamp(16.0, 20.0),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF2D2D2D)),
              onPressed: () {
                _loadTimeoutTimer?.cancel();
                if (_webViewController != null) {
                  _webViewController!.reload();
                  setState(() {
                    _status = 'Refreshing...';
                    _isLoading = true;
                  });
                }
              },
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: Column(
          children: [
            if (_status.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: _accessToken != null
                    ? Colors.green.shade50
                    : Colors.blue.shade50,
                child: Row(
                  children: [
                    if (_accessToken != null)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20)
                    else
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _status,
                        style: TextStyle(
                          color: _accessToken != null
                              ? Colors.green.shade900
                              : Colors.blue.shade900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('https://chatgpt.com'),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  transparentBackground: false,
                  allowsBackForwardNavigationGestures: true,
                  thirdPartyCookiesEnabled: true,
                  domStorageEnabled: true,
                  cacheEnabled: true,
                  userAgent:
                      'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
                  useShouldOverrideUrlLoading: true,
                  supportMultipleWindows: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                ),
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  // Allow all navigation
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStart: (controller, url) {
                  // Start timeout timer when page starts loading
                  _loadTimeoutTimer?.cancel();
                  _loadTimeoutTimer = Timer(const Duration(seconds: 30), () {
                    if (mounted && _status.contains('Opening ChatGPT login')) {
                      setState(() {
                        _status = 'Loading is taking too long. Try refreshing or check your internet connection.';
                        _isLoading = false;
                      });
                    }
                  });
                  
                  if (mounted) {
                    setState(() {
                      _status = 'Loading ChatGPT...';
                    });
                  }
                },
                onWebViewCreated: (controller) {
                  _webViewController = controller;

                  // Handler for token
                  controller.addJavaScriptHandler(
                    handlerName: 'onToken',
                    callback: (args) {
                      if (args.isNotEmpty && args.first is String) {
                        if (mounted) {
                          setState(() {
                            _accessToken = args.first as String;
                            _status = 'Successfully logged in! ✓';
                          });
                          _fetchConversations();
                        }
                      }
                      return {'ok': true};
                    },
                  );

                  // Handler for conversations
                  controller.addJavaScriptHandler(
                    handlerName: 'onChats',
                    callback: (args) {
                      if (args.isNotEmpty && args.first is String) {
                        try {
                          final map = jsonDecode(args.first as String)
                              as Map<String, dynamic>;
                          final items = (map['items'] as List?) ?? [];
                          if (items.isNotEmpty) {
                            if (mounted) {
                              setState(() {
                                _status = 'Loading messages... 0%';
                              });
                            }
                            // Fetch full conversation data with messages
                            _fetchFullConversations(items);
                          } else {
                            // No conversations found, complete login with empty list
                            if (mounted) {
                              setState(() {
                                _status = 'No conversations found.';
                                _conversations = [];
                                _isLoading = false;
                              });
                              Future.delayed(const Duration(milliseconds: 500), () {
                                if (!mounted) return;
                                _completeLogin();
                              });
                            }
                          }
                        } catch (_) {}
                      }
                      return {'ok': true};
                    },
                  );


                  // Handler for fetch errors
                  controller.addJavaScriptHandler(
                    handlerName: 'onFetchError',
                    callback: (args) {
                      if (args.isNotEmpty && args.first is String) {
                        final error = args.first as String;
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            if (error == 'SESSION_ERROR') {
                              _status = 'Session error. Please try logging in again.';
                            } else if (error == 'NO_TOKEN') {
                              _status = 'Authentication failed. Please log in again.';
                            } else if (error == 'FETCH_ERROR') {
                              _status = 'Failed to fetch conversations. Please try again.';
                            } else {
                              _status = 'Error: $error';
                            }
                          });
                        }
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_status),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        }
                      }
                      return {'ok': true};
                    },
                  );
                },
                onLoadStop: (controller, url) async {
                  // Cancel timeout when page loads
                  _loadTimeoutTimer?.cancel();
                  
                  if (mounted) {
                    setState(() {
                      _status = 'Please sign in to AI...';
                    });
                  }
                  await _checkLoginStatus();
                },
                onReceivedError: (controller, request, error) {
                  // Cancel timeout on error
                  _loadTimeoutTimer?.cancel();
                  
                  // Ignore errors for third-party resources (analytics, ads, etc.)
                  // Only show errors for main AI domain
                  final url = request.url.toString();
                  final isMainDomain = url.contains('chatgpt.com') || 
                                     url.contains('openai.com') ||
                                     url.isEmpty; // Empty URL means main page
                  
                  // Ignore common non-critical errors (third-party resources that fail to load)
                  final errorDescription = error.description.toLowerCase();
                  final isNonCriticalError = errorDescription.contains('err_name_not_resolved') ||
                                            errorDescription.contains('net::err_name_not_resolved') ||
                                            errorDescription.contains('name not resolved') ||
                                            (!isMainDomain); // Ignore all third-party errors
                  
                  // Only show error if it's for main domain and not a non-critical error
                  if (isMainDomain && !isNonCriticalError) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _status = 'Failed to load page. Error: ${error.description}. Try refreshing.';
                      });
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Network error: ${error.description}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 5),
                          action: SnackBarAction(
                            label: 'Refresh',
                            textColor: Colors.white,
                            onPressed: () {
                              if (_webViewController != null) {
                                _webViewController!.reload();
                                setState(() {
                                  _status = 'Refreshing...';
                                  _isLoading = true;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    }
                  }
                  // Silently ignore third-party resource errors and ERR_NAME_NOT_RESOLVED
                },
                onReceivedHttpError: (controller, request, response) {
                  // Cancel timeout on HTTP error
                  _loadTimeoutTimer?.cancel();
                  
                  final url = request.url.toString();
                  final isMainDomain = url.contains('chatgpt.com') || url.contains('openai.com');
                  
                  if (isMainDomain && response.statusCode != null && response.statusCode! >= 400) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _status = 'HTTP Error ${response.statusCode}. Try refreshing.';
                      });
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('HTTP Error ${response.statusCode}. Please try again.'),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'Refresh',
                            textColor: Colors.white,
                            onPressed: () {
                              if (_webViewController != null) {
                                _webViewController!.reload();
                                setState(() {
                                  _status = 'Refreshing...';
                                  _isLoading = true;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5), // Off-white
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final viewInsets = MediaQuery.of(context).viewInsets.bottom;
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: viewInsets + 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const Spacer(flex: 2),

                          // App Name
                          Text(
                            'MyChatEra',
                            style: TextStyle(
                              fontSize: (screenWidth * 0.12)
                                  .clamp(36.0, isLargeScreen ? 64.0 : 56.0),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D2D2D),
                              letterSpacing: -1.0,
                            ),
                          ),

                          SizedBox(height: (screenHeight * 0.02).clamp(16.0, 24.0)),

                          // Tagline
                          Text(
                            'Sign in to get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (screenWidth * 0.045)
                                  .clamp(16.0, isLargeScreen ? 24.0 : 22.0),
                              color: const Color(0xFF2D2D2D).withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),

                          SizedBox(height: (screenHeight * 0.05).clamp(32.0, 48.0)),

                          // Email field
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your ChatGPT email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    (screenWidth * 0.04).clamp(14.0, 20.0)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),

                          SizedBox(height: (screenHeight * 0.02).clamp(16.0, 24.0)),

                          // Password field
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    (screenWidth * 0.04).clamp(14.0, 20.0)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                          ),

                          SizedBox(height: (screenHeight * 0.04).clamp(24.0, 32.0)),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: (screenHeight * 0.07).clamp(48.0, 64.0),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _isLoading ? null : _handleLogin,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFFB4A2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      (screenWidth * 0.04).clamp(14.0, 20.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B9D).withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Continue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: (screenWidth * 0.042)
                                                .clamp(15.0,
                                                    isLargeScreen ? 22.0 : 20.0),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: (screenHeight * 0.03).clamp(20.0, 32.0)),

                          // Terms and Privacy Policy
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Text(
                                'By continuing I am accepting',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.032)
                                      .clamp(11.0, 14.0),
                                  color:
                                      const Color(0xFF2D2D2D).withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final url = Uri.parse('https://github.com/maarijaperic/myChatEra-legal/blob/main/TERMS_OF_SERVICE.md');
                                  try {
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Could not open Terms of Service'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Terms of Use',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: (screenWidth * 0.032)
                                        .clamp(11.0, 14.0),
                                    color: const Color(0xFFFF6B9D),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                'and',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.032)
                                      .clamp(11.0, 14.0),
                                  color:
                                      const Color(0xFF2D2D2D).withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final url = Uri.parse('https://github.com/maarijaperic/myChatEra-legal/blob/main/PRIVACY_POLICY.md');
                                  try {
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Could not open Privacy Policy'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Privacy Policy',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: (screenWidth * 0.032)
                                        .clamp(11.0, 14.0),
                                    color: const Color(0xFFFF6B9D),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: (screenHeight * 0.02).clamp(12.0, 20.0)),

                          // Privacy note
                          Text(
                            'We never store your passwords.\nAll authentication happens securely through AI.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF2D2D2D).withOpacity(0.4),
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),

                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

