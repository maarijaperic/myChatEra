import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'services/data_processor.dart';
import 'models/chat_data.dart';

class ImportDataScreen extends StatefulWidget {
  const ImportDataScreen({super.key});

  @override
  State<ImportDataScreen> createState() => _ImportDataScreenState();
}

class _ImportDataScreenState extends State<ImportDataScreen> {
  final _textController = TextEditingController();
  bool _isProcessing = false;
  String? _statusMessage;
  ChatStats? _processedStats;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _processData() async {
    if (_textController.text.trim().isEmpty) {
      setState(() => _statusMessage = 'Please paste conversation data');
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Processing...';
    });

    try {
      // Parse JSON
      final jsonData = jsonDecode(_textController.text);
      final List<dynamic> conversations = jsonData is List ? jsonData : [jsonData];

      // Process and calculate stats
      final stats = await DataProcessor.processConversationsFromJson(conversations);

      setState(() {
        _isProcessing = false;
        _processedStats = stats;
        _statusMessage = 'Success! Processed ${stats.totalConversations} conversations.';
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _textController.text = data!.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Chat Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.paste),
            onPressed: _pasteFromClipboard,
            tooltip: 'Paste from clipboard',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How to import:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('1. Open ChatFetcher app'),
                    const Text('2. Fetch your conversations'),
                    const Text('3. Tap "Export for GPT Wrapped"'),
                    const Text('4. Come back here and paste the data'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Paste conversation JSON data:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '[\n  {"id": "...", "title": "...", ...}\n]',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isProcessing ? null : _processData,
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Process Data'),
            ),
            if (_statusMessage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _processedStats != null ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _statusMessage!,
                        style: TextStyle(
                          color: _processedStats != null ? Colors.green.shade900 : Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_processedStats != null) ...[
                        const SizedBox(height: 12),
                        Text('Total chats: ${_processedStats!.totalConversations}'),
                        Text('Longest streak: ${_processedStats!.longestStreak} days'),
                        Text('Messages/day: ${_processedStats!.messagesPerDay}'),
                        Text('Peak time: ${_processedStats!.peakTime}'),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Signal to reload
                          },
                          child: const Text('Done - View My Wrapped'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


