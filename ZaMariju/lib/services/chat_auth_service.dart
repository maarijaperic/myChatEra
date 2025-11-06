import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChatAuthService {
  static Future<AuthResult> loginWithWebView(BuildContext context) async {
    String? accessToken;
    List<dynamic>? conversations;
    
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => _ChatGPTLoginScreen(
          onAuthComplete: (token, convos) {
            accessToken = token;
            conversations = convos;
          },
        ),
      ),
    );
    
    if (result != null && result['success'] == true) {
      return AuthResult(
        success: true,
        accessToken: result['token'] as String?,
        conversations: result['conversations'] as List<dynamic>?,
      );
    }
    
    return AuthResult(
      success: false,
      error: result?['error'] as String? ?? 'Login cancelled',
    );
  }
}

class AuthResult {
  final bool success;
  final String? accessToken;
  final List<dynamic>? conversations;
  final String? error;
  
  AuthResult({
    required this.success,
    this.accessToken,
    this.conversations,
    this.error,
  });
}

class _ChatGPTLoginScreen extends StatefulWidget {
  final Function(String? token, List<dynamic>? conversations) onAuthComplete;
  
  const _ChatGPTLoginScreen({required this.onAuthComplete});
  
  @override
  State<_ChatGPTLoginScreen> createState() => _ChatGPTLoginScreenState();
}

class _ChatGPTLoginScreenState extends State<_ChatGPTLoginScreen> {
  InAppWebViewController? _controller;
  String _status = 'Loading ChatGPT...';
  bool _isLoggedIn = false;
  String? _accessToken;
  List<dynamic>? _conversations;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to ChatGPT'),
        actions: [
          if (_isLoggedIn)
            TextButton(
              onPressed: _completeLogin,
              child: const Text('Continue'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: _isLoggedIn ? Colors.green.shade50 : Colors.blue.shade50,
            child: Row(
              children: [
                if (_isLoggedIn)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20)
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
                      color: _isLoggedIn ? Colors.green.shade900 : Colors.blue.shade900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // WebView
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
                userAgent: 'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
                
                // Handler for token
                controller.addJavaScriptHandler(
                  handlerName: 'onToken',
                  callback: (args) {
                    if (args.isNotEmpty && args.first is String) {
                      setState(() {
                        _accessToken = args.first as String;
                        _isLoggedIn = true;
                        _status = 'Successfully logged in! ✓';
                      });
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
                        final map = jsonDecode(args.first as String) as Map<String, dynamic>;
                        final items = (map['items'] as List?) ?? [];
                        if (items.isNotEmpty) {
                          setState(() {
                            _conversations = items;
                          });
                        }
                      } catch (_) {}
                    }
                    return {'ok': true};
                  },
                );
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _status = 'Please sign in to ChatGPT...';
                });
                
                // Check if logged in
                await _checkLoginStatus();
              },
            ),
          ),
          
          // Bottom actions
          if (_isLoggedIn)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _completeLogin,
                      icon: const Icon(Icons.check),
                      label: const Text('Continue to GPT Wrapped'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _fetchConversations(),
                    child: const Text('Fetch my conversations (optional)'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Future<void> _checkLoginStatus() async {
    if (_controller == null) return;
    
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
    
    final result = await _controller!.evaluateJavascript(source: js);
    if (result == 'LOGGED_IN') {
      setState(() {
        _isLoggedIn = true;
        _status = 'Successfully logged in! ✓';
      });
    }
  }
  
  Future<void> _fetchConversations() async {
    if (_controller == null) return;
    
    setState(() => _status = 'Fetching your conversations...');
    
    const js = '''
      (async function() {
        let all = [];
        try {
          const sessionResp = await fetch('/api/auth/session', { credentials: 'include' });
          if (!sessionResp.ok) return 'SESSION_ERROR';
          
          const session = await sessionResp.json();
          const token = session && session.accessToken ? session.accessToken : null;
          if (!token) return 'NO_TOKEN';
          
          const resp = await fetch('/backend-api/conversations?offset=0&limit=100&order=updated', {
            method: 'GET',
            headers: {
              'Authorization': 'Bearer ' + token,
              'Accept': 'application/json'
            },
            credentials: 'include'
          });
          
          if (!resp.ok) return 'FETCH_ERROR';
          
          const json = await resp.json();
          const items = (json && json.items) ? json.items : [];
          
          window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: items, done: true }));
          return 'OK';
        } catch (e) {
          return 'ERROR:' + (e && e.message ? e.message : String(e));
        }
      })();
    ''';
    
    await _controller!.evaluateJavascript(source: js);
    
    setState(() {
      _status = _conversations != null && _conversations!.isNotEmpty
          ? 'Fetched ${_conversations!.length} conversations ✓'
          : 'Successfully logged in! ✓';
    });
  }
  
  void _completeLogin() {
    widget.onAuthComplete(_accessToken, _conversations);
    Navigator.of(context).pop({
      'success': true,
      'token': _accessToken,
      'conversations': _conversations,
    });
  }
}























