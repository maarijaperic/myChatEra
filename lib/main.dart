import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT WebView PoC',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InAppWebViewController? _controller;
  String _status = 'Open chatgpt.com and log in…';
  String? _lastToken;
  String? _lastChatsPreview;
  bool _debugExpanded = false;
  List<dynamic> _conversations = [];
  Completer<List<dynamic>>? _convCompleter;

  final _chatgptUri = WebUri('https://chatgpt.com');

  String _ellipsize(String value, int max) {
    if (value.length <= max) return value;
    return value.substring(0, max) + '…';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatGPT WebView PoC')),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: _chatgptUri),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                transparentBackground: false,
                allowsBackForwardNavigationGestures: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                supportMultipleWindows: true,
                javaScriptCanOpenWindowsAutomatically: true,
                thirdPartyCookiesEnabled: true,
                domStorageEnabled: true,
                userAgent: 'Mozilla/5.0 (Linux; Android 14; Pixel 7 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
              ),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                // If this is a target=_blank or no target frame, open in same view
                if (navigationAction.targetFrame == null ||
                    navigationAction.isForMainFrame == false) {
                  if (uri != null) {
                    await controller.loadUrl(urlRequest: navigationAction.request);
                  }
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onCreateWindow: (controller, request) async {
                // Handle OAuth popups (Google/Apple) by opening a new WebView
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (ctx) {
                    return Dialog(
                      insetPadding: const EdgeInsets.all(12),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: MediaQuery.of(ctx).size.width * 0.95,
                        height: MediaQuery.of(ctx).size.height * 0.85,
        child: Column(
                          children: [
                            Container(
                              height: 44,
                              color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Login'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: InAppWebView(
                                // Attach to popup window
                                windowId: request.windowId,
                                initialSettings: InAppWebViewSettings(
                                  javaScriptEnabled: true,
                                  allowsInlineMediaPlayback: true,
                                  mediaPlaybackRequiresUserGesture: false,
                                  supportMultipleWindows: true,
                                  javaScriptCanOpenWindowsAutomatically: true,
                                  thirdPartyCookiesEnabled: true,
                                  domStorageEnabled: true,
                                ),
                                onCloseWindow: (c) {
                                  if (Navigator.of(ctx).canPop()) {
                                    Navigator.of(ctx).pop();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                return true;
              },
              onWebViewCreated: (c) async {
                _controller = c;
                // Third-party cookies are enabled via settings above.

                // Receive conversations (partial or full) from JS
                c.addJavaScriptHandler(
                  handlerName: 'onChats',
                  callback: (args) {
                    // Expect a single JSON string:
                    // { items: [...], error: '...', done: true/false, message?, body? }
                    if (args.isEmpty || args.first is! String) return {'ok': false};

                    final raw = args.first as String;
                    try {
                      final map = jsonDecode(raw) as Map<String, dynamic>;
                      final items = (map['items'] as List?) ?? [];
                      final done = map['done'] == true;
                      final err  = map['error'] as String?;
                      setState(() {
                        _conversations = items;
                        _lastChatsPreview =
                            raw.length > 2000 ? '${raw.substring(0, 2000)}…' : raw;
                        _status = done
                            ? 'Fetched ${items.length} conversations.'
                            : 'Partial fetch: ${items.length} conversations'
                              '${err != null ? ' (error: $err)' : ''}';
                      });
                    } catch (_) {
                      setState(() {
                        _lastChatsPreview = raw;
                        _status = 'Received conversations (raw).';
                      });
                    }
                    return {'ok': true};
                  },
                );

                // Receive token from JS
                c.addJavaScriptHandler(
                  handlerName: 'onToken',
                  callback: (args) {
                    if (args.isNotEmpty && args.first is String) {
                      setState(() {
                        _lastToken = args.first as String;
                        _status = 'Access token captured.';
                      });
                    }
                    return {'ok': true};
                  },
                );

                // Receive single conversation messages from JS
                c.addJavaScriptHandler(
                  handlerName: 'onConversation',
                  callback: (args) {
                    if (args.isEmpty || args.first is! String) return {'ok': false};
                    try {
                      final map = jsonDecode(args.first as String) as Map<String, dynamic>;
                      final items = (map['items'] as List?) ?? [];
                      if (_convCompleter != null && !(_convCompleter!.isCompleted)) {
                        _convCompleter!.complete(items);
                      }
                      setState(() {
                        _status = map['done'] == true
                            ? 'Conversation loaded (${items.length} messages).'
                            : (map['error'] != null ? 'Conv error: ${map['error']}' : 'Conversation update');
                      });
                    } catch (_) {
                      if (_convCompleter != null && !(_convCompleter!.isCompleted)) {
                        _convCompleter!.complete([]);
                      }
                    }
                    return {'ok': true};
                  },
                );
              },
              onLoadStop: (controller, url) async {
                setState(() =>
                    _status = 'Loaded: ${url?.toString() ?? ''}. Log in if needed.');
              },
            ),
          ),
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _ellipsize(_status, 60),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => setState(() => _debugExpanded = !_debugExpanded),
                        icon: Icon(_debugExpanded ? Icons.expand_more : Icons.expand_less),
                        label: Text(_debugExpanded ? 'Less' : 'More'),
                      )
                    ],
                  ),
                  if (_debugExpanded) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton(
                          onPressed: _getAccessTokenFromWebView,
                          child: const Text('Get access token'),
                        ),
                        FilledButton.tonal(
                          onPressed: _fetchUpTo100ConversationsInsideWebView,
                          child: const Text('Fetch up to 100 convos'),
                        ),
                        if (_conversations.isNotEmpty)
                          OutlinedButton(
                            onPressed: _openConversationsList,
                            child: const Text('View JSON'),
                          ),
                        OutlinedButton(
                          onPressed: () async => _controller?.reload(),
                          child: const Text('Reload'),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            await _controller?.loadUrl(
                              urlRequest: URLRequest(url: _chatgptUri),
                            );
                          },
                          child: const Text('Go to chatgpt.com'),
            ),
          ],
        ),
                    const SizedBox(height: 8),
                    if (_lastToken != null)
                      Text(
                        'Token (first 80 chars): '
                        '${_lastToken!.substring(0, _lastToken!.length > 80 ? 80 : _lastToken!.length)}…',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    const SizedBox(height: 8),
                    if (_lastChatsPreview != null) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Conversations JSON (truncated preview):'),
                      ),
                      const SizedBox(height: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _lastChatsPreview!,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Runs JS inside the WebView to call /api/auth/session and extract `accessToken`.
  Future<void> _getAccessTokenFromWebView() async {
    if (_controller == null) return;
    setState(() => _status = 'Trying to read access token from session…');

    final js = '''
      (async function() {
        try {
          async function getSession() {
            try {
              const r = await fetch('/api/auth/session', { credentials: 'include' });
              if (r.ok) return r.json();
            } catch (e) {}
            try {
              const r2 = await fetch('https://chatgpt.com/api/auth/session', { credentials: 'include' });
              if (r2.ok) return r2.json();
            } catch (e) {}
            return null;
          }
          const data = await getSession();
          const token = data && data.accessToken ? data.accessToken : '';
          if (token) {
            window.flutter_inappwebview.callHandler('onToken', token);
            return token;
          } else {
            return 'NO_TOKEN';
          }
        } catch (e) {
          return 'ERROR:' + (e && e.message ? e.message : String(e));
        }
      })();
    ''';

    final result = await _controller!.evaluateJavascript(source: js);
    if (result is String && result.startsWith('ERROR')) {
      setState(() => _status = 'Error getting token: $result');
    } else if (result == 'NO_TOKEN') {
      setState(() => _status = 'No token. Are you logged in? Try refreshing.');
    } else {
      setState(() => _status = 'Access token attempt finished (see above).');
    }
  }

  /// Fetch up to 100 conversations. If something fails, returns partial results.
  Future<void> _fetchUpTo100ConversationsInsideWebView() async {
    if (_controller == null) return;
    setState(() => _status = 'Fetching up to 100 conversations…');

    final js = '''
      (async function() {
        let all = [];
        try {
          // Get a fresh access token
          const sessionResp = await fetch('/api/auth/session', { credentials: 'include' });
          if (!sessionResp.ok) {
            const body = await sessionResp.text();
            window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: all, error: 'HTTP_SESSION_' + sessionResp.status, body, done: false }));
            return 'HTTP_SESSION_' + sessionResp.status;
          }
          const session = await sessionResp.json();
          const token = session && session.accessToken ? session.accessToken : null;
          if (!token) {
            window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: all, error: 'NO_TOKEN', done: false }));
            return 'NO_TOKEN';
          }

          let offset = 0;
          const maxTotal = 100;

          while (all.length < maxTotal) {
            const remaining = maxTotal - all.length;
            const limit = Math.min(50, remaining);
            const url = '/backend-api/conversations?offset=' + offset + '&limit=' + limit + '&order=updated';

            const resp = await fetch(url, {
              method: 'GET',
              headers: {
                'Authorization': 'Bearer ' + token,
                'Accept': 'application/json',
                'Content-Type': 'application/json'
              },
              credentials: 'include'
            });

            if (!resp.ok) {
              const body = await resp.text();
              window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: all, error: 'HTTP_' + resp.status, body, done: false }));
              return 'HTTP_' + resp.status;
            }

            const json = await resp.json();
            const items = (json && (json.items || json.data)) ? (json.items || json.data) : [];
            if (!items || items.length === 0) break;

            all = all.concat(items);
            offset += items.length;
          }

          window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: all, error: null, done: true }));
          return 'OK';
        } catch (e) {
          const msg = (e && e.message) ? e.message : String(e);
          window.flutter_inappwebview.callHandler('onChats', JSON.stringify({ items: all, error: 'JS_ERR', message: msg, done: false }));
          return 'ERROR:' + msg;
        }
      })();
    ''';

    final result = await _controller!.evaluateJavascript(source: js);
    if (result is String && result.startsWith('ERROR')) {
      setState(() => _status = 'JS error: $result (partial may be shown below).');
    } else if (result is String && result.startsWith('HTTP')) {
      setState(() => _status = 'HTTP error: $result (partial may be shown below).');
    } else if (result == 'NO_TOKEN') {
      setState(() => _status = 'No token (log in first). Partial = 0.');
    } else {
      setState(() => _status = 'Fetch finished (see JSON below).');
    }
  }

  void _openConversationsList() {
    final conversations = _conversations;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.9,
          child: Column(
            children: [
              Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: const Text('Conversations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (ctx, index) {
                    final conv = conversations[index] as Map? ?? {};
                    final title = (conv['title'] as String?) ?? 'Untitled';
                    final id = (conv['id'] as String?) ?? (conv['conversation_id'] as String?) ?? '';
                    final createTime = conv['create_time'] ?? conv['created'] ?? '';
                    return InkWell(
                      onTap: id.isEmpty ? null : () => _openConversationMessages(id, title),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.chat_bubble_outline, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(id, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                ],
                              ),
                            ),
                            if (createTime is String && createTime.isNotEmpty)
                              Text(createTime, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openConversationMessages(String conversationId, String title) async {
    if (_controller == null) return;

    setState(() => _status = 'Loading conversation…');
    _convCompleter = Completer<List<dynamic>>();

    final js = '''
      (async function() {
        try {
          const sessionResp = await fetch('/api/auth/session', { credentials: 'include' });
          if (!sessionResp.ok) { return 'HTTP_SESSION_' + sessionResp.status; }
          const session = await sessionResp.json();
          const token = session && session.accessToken ? session.accessToken : null;
          if (!token) { return 'NO_TOKEN'; }

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
          if (!resp.ok) { return 'HTTP_' + resp.status; }
          const json = await resp.json();
          const items = json && json.mapping ? Object.values(json.mapping) : [];
          window.flutter_inappwebview.callHandler('onConversation', JSON.stringify({ items, done: true }));
          return 'OK';
        } catch (e) {
          const msg = (e && e.message) ? e.message : String(e);
          window.flutter_inappwebview.callHandler('onConversation', JSON.stringify({ items: [], error: msg, done: false }));
          return 'ERROR:' + msg;
        }
      })();
    ''';

    unawaited(_controller!.evaluateJavascript(source: js));
    final messages = await _convCompleter!.future.catchError((_) => <dynamic>[]);
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => _ConversationScreen(title: title, messages: messages),
      ),
    );
  }
}

class _ConversationScreen extends StatelessWidget {
  final String title;
  final List<dynamic> messages;
  const _ConversationScreen({super.key, required this.title, required this.messages});

  @override
  Widget build(BuildContext context) {
    // Extract message-like nodes from mapping items
    final nodes = messages
        .map((e) => e is Map ? e : null)
        .whereType<Map>()
        .where((m) => m['message'] != null)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(title.isEmpty ? 'Conversation' : title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: nodes.length,
        itemBuilder: (ctx, i) {
          final node = nodes[i];
          final msg = node['message'] as Map? ?? {};
          final author = (msg['author'] as Map?) ?? {};
          final role = (author['role'] as String?) ?? 'user';
          final isUser = role == 'user';
          final parts = (msg['content'] as Map?)?['parts'] as List? ?? [];
          final text = parts.isNotEmpty ? (parts.first is String ? parts.first as String : (parts.first['text'] ?? '').toString()) : '';

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.smart_toy, size: 18),
                ),
              if (!isUser) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue.shade600 : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 2),
                      bottomRight: Radius.circular(isUser ? 2 : 14),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8),
              if (isUser)
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.person, size: 18, color: Colors.blue),
                ),
            ],
          );
        },
      ),
    );
  }
}
