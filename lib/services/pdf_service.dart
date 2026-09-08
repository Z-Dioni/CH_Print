import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/vehicle.dart';

class PdfService {
  static const String defaultSeparator = ' * ';
  static const String defaultFont = 'Arial Black';

  static const List<String> availableFonts = [
    'Arial Black',
    'Noto Sans Display Bold',
    'DejaVu Sans Bold',
  ];

  static const double labelFontSize = 1000;

  static String formatChassisLabel(
    String chassisNumber, {
    String separator = defaultSeparator,
  }) {
    return 'CH$separator$chassisNumber';
  }

  static String getSafeSeparatorForPdf(String separator) {
    final normalized = separator;

    if (normalized.trim().isEmpty) {
      return defaultSeparator;
    }

    return normalized;
  }

  static String? _getFlagCode(String value) {
    final runes = value.runes.toList();
    if (runes.length != 2 ||
        runes.any((rune) => rune < 0x1F1E6 || rune > 0x1F1FF)) {
      return null;
    }

    return String.fromCharCodes(runes.map((rune) => rune - 0x1F1E6 + 0x41));
  }

  static String _flagSvg(String code) {
    switch (code) {
      case 'FR':
      case 'IT':
      case 'BE':
      case 'IE':
      case 'CI':
        final colors = {
          'FR': ['#0055A4', '#FFFFFF', '#EF4135'],
          'IT': ['#009246', '#FFFFFF', '#CE2B37'],
          'BE': ['#000000', '#FDD835', '#EF3340'],
          'IE': ['#169B62', '#FFFFFF', '#FF883E'],
          'CI': ['#FF8200', '#FFFFFF', '#009A44'],
        }[code]!;
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
            '<rect width="1" height="2" fill="${colors[0]}"/>'
            '<rect x="1" width="1" height="2" fill="${colors[1]}"/>'
            '<rect x="2" width="1" height="2" fill="${colors[2]}"/></svg>';
      case 'DE':
      case 'NL':
      case 'LU':
      case 'RU':
      case 'UA':
      case 'PL':
        final colors = {
          'DE': ['#000000', '#DD0000', '#FFCE00'],
          'NL': ['#AE1C28', '#FFFFFF', '#21468B'],
          'LU': ['#EF3340', '#FFFFFF', '#00A3E0'],
          'RU': ['#FFFFFF', '#0039A6', '#D52B1E'],
          'UA': ['#0057B7', '#FFDD00', '#FFDD00'],
          'PL': ['#FFFFFF', '#DC143C', '#DC143C'],
        }[code]!;
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
            '<rect width="3" height="0.67" fill="${colors[0]}"/>'
            '<rect y="0.67" width="3" height="0.67" fill="${colors[1]}"/>'
            '<rect y="1.34" width="3" height="0.66" fill="${colors[2]}"/></svg>';
      case 'DZ':
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
            '<rect width="1.5" height="2" fill="#006233"/>'
            '<rect x="1.5" width="1.5" height="2" fill="#FFFFFF"/>'
            '<circle cx="1.5" cy="1" r="0.48" fill="#D21034"/>'
            '<circle cx="1.68" cy="1" r="0.38" fill="#FFFFFF"/></svg>';
      case 'ML':
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
            '<rect width="1" height="2" fill="#14B53A"/>'
            '<rect x="1" width="1" height="2" fill="#FCD116"/>'
            '<rect x="2" width="1" height="2" fill="#CE1126"/></svg>';
      case 'MA':
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
            '<rect width="3" height="2" fill="#C1272D"/>'
            '<path d="M1.5 .35 1.68 1.2 2.4 .72 1.9 1.5 1.5 1.15 1.1 1.5 .6 .72 1.32 1.2Z" '
            'fill="none" stroke="#006233" stroke-width=".08"/></svg>';
      default:
        return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 2">'
            '<rect width="3" height="2" fill="#1976D2"/>'
            '<rect y=".85" width="3" height=".3" fill="#FFFFFF"/></svg>';
    }
  }

  static Future<String> getLabelSeparator() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSeparator = prefs.getString('ch_print_label_separator');

      if (savedSeparator == null || savedSeparator.trim().isEmpty) {
        return defaultSeparator;
      }

      return savedSeparator;
    } on PlatformException {
      return defaultSeparator;
    } catch (_) {
      return defaultSeparator;
    }
  }

  static Future<String> getLabelFont() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFont = prefs.getString('ch_print_label_font');

      if (savedFont != null && availableFonts.contains(savedFont)) {
        return savedFont;
      }
    } catch (_) {}

    return defaultFont;
  }

  static Future<pw.Font> _loadSymbolFont() async {
    final fontData = await rootBundle.load(
      'assets/NotoSansSymbols2-Regular.ttf',
    );
    return pw.Font.ttf(fontData);
  }

  static Future<pw.Font> _loadEmojiFont() async {
    final fontData = await rootBundle.load('assets/FreeSans.ttf');
    return pw.Font.ttf(fontData);
  }

  static Future<pw.Font> _loadLabelFont(String fontName) async {
    final assetPath = switch (fontName) {
      'Noto Sans Display Bold' => 'assets/NotoSansDisplay-Bold.ttf',
      'DejaVu Sans Bold' => 'assets/DejaVuSans-Bold.ttf',
      _ => 'assets/Arial_Black.ttf',
    };
    final fontData = await rootBundle.load(assetPath);
    return pw.Font.ttf(fontData);
  }

  /// Génère le document PDF à partir de la liste des véhicules
  static Future<Uint8List> generatePdf(List<Vehicle> vehicles) async {
    final pdf = pw.Document();
    final separator = getSafeSeparatorForPdf(await getLabelSeparator());
    final fontName = await getLabelFont();
    final labelFont = await _loadLabelFont(fontName);
    final symbolFont = await _loadSymbolFont();
    final emojiFont = await _loadEmojiFont();

    // 1. Pagination : On parcourt la liste avec un pas de 2
    for (var i = 0; i < vehicles.length; i += 2) {
      final chunk = vehicles.sublist(
        i,
        i + 2 > vehicles.length ? vehicles.length : i + 2,
      );

      // 2. Création de la page A4 en orientation PORTRAIT
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4, // Mode portrait
          // Marges réduites au maximum pour utiliser tout le papier
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Expanded(
                  child: _buildLabel(
                    chunk[0].chassisNumber,
                    separator,
                    labelFont,
                    symbolFont,
                    emojiFont,
                  ),
                ),
                pw.Expanded(
                  child: _buildLabel(
                    chunk[0].chassisNumber,
                    separator,
                    labelFont,
                    symbolFont,
                    emojiFont,
                  ),
                ),

                if (chunk.length > 1) ...[
                  pw.Expanded(
                    child: _buildLabel(
                      chunk[1].chassisNumber,
                      separator,
                      labelFont,
                      symbolFont,
                      emojiFont,
                    ),
                  ),
                  pw.Expanded(
                    child: _buildLabel(
                      chunk[1].chassisNumber,
                      separator,
                      labelFont,
                      symbolFont,
                      emojiFont,
                    ),
                  ),
                ] else ...[
                  pw.Expanded(child: pw.Container()),
                  pw.Expanded(child: pw.Container()),
                ],
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  /// Construit une étiquette individuelle
  static pw.Widget _buildLabel(
    String chassisNumber,
    String separator,
    pw.Font labelFont,
    pw.Font symbolFont,
    pw.Font emojiFont,
  ) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey400,
          width: 1,
          style: pw.BorderStyle.dashed,
        ),
      ),
      padding: pw.EdgeInsets.zero,
      child: pw.Center(
        child: pw.FittedBox(
          fit: pw.BoxFit.fill,
          child: pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'CH',
                style: _labelTextStyle(labelFont, [emojiFont, symbolFont]),
              ),
              _buildSeparator(separator, labelFont, emojiFont, symbolFont),
              pw.Text(
                chassisNumber,
                style: _labelTextStyle(labelFont, [emojiFont, symbolFont]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static pw.TextStyle _labelTextStyle(
    pw.Font labelFont,
    List<pw.Font> fallback,
  ) {
    return pw.TextStyle(
      fontSize: labelFontSize,
      font: labelFont,
      fontFallback: fallback,
    );
  }

  static pw.Widget _buildSeparator(
    String separator,
    pw.Font labelFont,
    pw.Font emojiFont,
    pw.Font symbolFont,
  ) {
    final flagCode = _getFlagCode(separator.trim());
    if (flagCode == null) {
      return pw.Text(
        separator,
        style: _labelTextStyle(labelFont, [emojiFont, symbolFont]),
      );
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 25),
      child: pw.SvgImage(
        svg: _flagSvg(flagCode),
        width: labelFontSize * 0.9,
        height: labelFontSize * 0.6,
      ),
    );
  }
}
