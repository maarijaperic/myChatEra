import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:gpt_wrapped2/models/chat_data.dart';
import 'package:gpt_wrapped2/services/premium_processor.dart';
import 'package:share_plus/share_plus.dart';

class PDFGenerator {
  /// Generate PDF with all premium insights
  static Future<String?> generatePremiumAnalysisPDF({
    required PremiumInsights insights,
    ChatStats? stats,
  }) async {
    try {
      final pdf = pw.Document();
      
      // Add pages for each premium insight
      pdf.addPage(
        _buildCoverPage(insights),
      );
      
      pdf.addPage(
        _buildMBTIPage(insights),
      );
      
      pdf.addPage(
        _buildTypeABPage(insights),
      );
      
      pdf.addPage(
        _buildRedGreenFlagsPage(insights),
      );
      
      pdf.addPage(
        _buildZodiacPage(insights),
      );
      
      pdf.addPage(
        _buildSongPage(insights),
      );
      
      pdf.addPage(
        _buildIntroExtroPage(insights),
      );
      
      pdf.addPage(
        _buildAdvicePage(insights),
      );
      
      pdf.addPage(
        _buildMoviePage(insights),
      );
      
      pdf.addPage(
        _buildRoastPage(insights),
      );
      
      pdf.addPage(
        _buildLoveLanguagePage(insights),
      );
      
      pdf.addPage(
        _buildPastLifePage(insights),
      );
      
      // Save PDF to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/GPT_Wrapped_Analysis_$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      
      return filePath;
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }
  
  static pw.Page _buildCoverPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Your GPT Wrapped',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Premium Analysis Report',
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                'Generated: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildMBTIPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'MBTI Personality Type',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.mbtiType,
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                insights.personalityName,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.mbtiExplanation,
                style: pw.TextStyle(
                  fontSize: 12,
                ),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildTypeABPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Type A vs Type B Personality',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.personalityType,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Type A: ${insights.typeAPercentage}%',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Container(
                          height: 20,
                          width: double.infinity,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue300,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Type B: ${insights.typeBPercentage}%',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Container(
                          height: 20,
                          width: double.infinity,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.green300,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.typeExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildRedGreenFlagsPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Red & Green Flags',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Green Flags 🟢',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
              pw.SizedBox(height: 10),
              ...insights.greenFlags.map((flag) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  '• $flag',
                  style: pw.TextStyle(fontSize: 12),
                ),
              )),
              pw.SizedBox(height: 20),
              pw.Text(
                'Red Flags 🔴',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red700,
                ),
              ),
              pw.SizedBox(height: 10),
              ...insights.redFlags.map((flag) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  '• $flag',
                  style: pw.TextStyle(fontSize: 12),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildZodiacPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Zodiac Sign',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.zodiacSign,
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                insights.zodiacName,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.zodiacExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildSongPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Your Life Song',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.songTitle,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'by ${insights.songArtist} (${insights.songYear})',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.songExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildIntroExtroPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Introvert vs Extrovert',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.introExtroType,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Introvert: ${insights.introvertPercentage}%',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Container(
                          height: 20,
                          width: double.infinity,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue300,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Extrovert: ${insights.extrovertPercentage}%',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Container(
                          height: 20,
                          width: double.infinity,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.green300,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.introExtroExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildAdvicePage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Most Asked Advice',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.mostAskedAdvice,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Category: ${insights.adviceCategory}',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.adviceExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildMoviePage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Your Life Movie',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.movieTitle,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                '(${insights.movieYear})',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.movieExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildRoastPage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'AI Roast',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.roastText,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildLoveLanguagePage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Love Language',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.loveLanguage,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.loveLanguageExplanation,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  static pw.Page _buildPastLifePage(PremiumInsights insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(40),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Past Life Persona',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.personaTitle,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.pink700,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                insights.era,
                style: pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                insights.personaDescription,
                style: pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.justify,
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Share PDF file
  static Future<void> sharePDF(String filePath) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'My GPT Wrapped Premium Analysis',
      );
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }
}
