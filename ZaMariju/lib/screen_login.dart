import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
    int fetchedCount = 0;
    final totalCount = conversationList.length;

    for (var conv in conversationList) {
      if (conv is! Map<String, dynamic>) continue;
      
      final id = (conv['id'] as String?) ?? '';
      if (id.isEmpty) {
        fullConversations.add(conv);
        continue;
      }

      try {
        // Update status
        if (!mounted) return;
        setState(() {
          _status = 'Loading messages... ${fetchedCount + 1}/$totalCount';
        });

        // Fetch full conversation with messages
        final fullConv = await _fetchSingleConversation(id);
        if (fullConv != null) {
          fullConversations.add(fullConv);
        } else {
          // If fetch failed, include metadata only
          fullConversations.add(conv);
        }

        fetchedCount++;
        
        // Small delay to avoid rate limiting
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        print('Error fetching conversation $id: $e');
        // Include metadata only if fetch fails
        fullConversations.add(conv);
      }
    }

    if (!mounted) return;
    setState(() {
      _conversations = fullConversations;
      _status = 'Fetched ${fullConversations.length} conversations with messages ✓';
      _isLoading = false;
    });

    // Auto-complete login after fetching
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
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
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
    } finally {
      _webViewController!.removeJavaScriptHandler(handlerName: 'onConversationData');
    }
  }

  void _completeLogin() {
    // Clear password from memory (never stored)
    _passwordController.clear();
    
    // Pass conversations to the callback for analysis
    widget.onLoginSuccess(_conversations);
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
              setState(() {
                _showWebView = false;
                _isLoading = false;
              });
            },
          ),
          title: Text(
            'Sign in to ChatGPT',
            style: TextStyle(
              color: const Color(0xFF2D2D2D),
              fontSize: (screenWidth * 0.042).clamp(16.0, 20.0),
              fontWeight: FontWeight.w600,
            ),
          ),
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
                  userAgent:
                      'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
                ),
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
                                _status = 'Fetched ${items.length} conversations. Loading messages...';
                              });
                            }
                            // Fetch full conversation data with messages
                            _fetchFullConversations(items);
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
                  if (mounted) {
                    setState(() {
                      _status = 'Please sign in to ChatGPT...';
                    });
                  }
                  await _checkLoginStatus();
                },
                onReceivedError: (controller, request, error) {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                      _status = 'Failed to load page. Please check your internet connection.';
                    });
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Network error: ${error.description}'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                },
                onReceivedHttpError: (controller, request, response) {
                  if (response.statusCode != null && response.statusCode! >= 400) {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                        _status = 'Failed to connect. Please try again.';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Connection error: ${response.statusCode}'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
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
                                onTap: () {
                                  // TODO: Open Terms of Use
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Terms of Use'),
                                    ),
                                  );
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
                                onTap: () {
                                  // TODO: Open Privacy Policy
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Privacy Policy'),
                                    ),
                                  );
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
                            'We never store your passwords.\nAll authentication happens securely through ChatGPT.',
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

