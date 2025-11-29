import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;

class ShareHelper {
  /// Captures the screen using RepaintBoundary with GlobalKey and shares to Instagram Story
  static Future<void> shareToInstagramStory(
    BuildContext context,
    GlobalKey screenshotKey,
  ) async {
    await shareScreenToInstagram(context, screenshotKey);
  }

  /// Alternative method: Capture screen using RenderRepaintBoundary with GlobalKey
  static Future<void> shareScreenToInstagram(
    BuildContext context,
    GlobalKey key,
  ) async {
    try {
      // Show loading
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Wait for UI to settle
      await Future.delayed(const Duration(milliseconds: 300));

      // Get render repaint boundary
      final RenderRepaintBoundary? renderBoundary = 
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (renderBoundary == null) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to capture screen'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Capture image with high quality
      final image = await renderBoundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to capture screen'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final bytes = byteData.buffer.asUint8List();

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = path.join(
        directory.path,
        'gpt_wrapped_$timestamp.png',
      );

      final file = File(imagePath);
      await file.writeAsBytes(bytes);

      // Close loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Share - Instagram will appear if installed
      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Check out my GPT Wrapped! #mychateraAI',
        );
      }

      // Clean up
      Future.delayed(const Duration(seconds: 5), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

