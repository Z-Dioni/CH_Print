import 'package:ch_print/services/pdf_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PdfService label formatting', () {
    test('uses the default separator between CH and the chassis number', () {
      expect(PdfService.formatChassisLabel('1234'), 'CH * 1234');
    });

    test('supports a custom separator', () {
      expect(PdfService.formatChassisLabel('1234', separator: '-'), 'CH-1234');
      expect(PdfService.formatChassisLabel('1234', separator: '✨'), 'CH✨1234');
      expect(PdfService.formatChassisLabel('1234', separator: '+'), 'CH+1234');
    });

    test('preserves emoji and spaces in PDF separators', () {
      expect(PdfService.getSafeSeparatorForPdf('✨'), '✨');
      expect(PdfService.getSafeSeparatorForPdf('🚘'), '🚘');
      expect(PdfService.getSafeSeparatorForPdf(' * '), ' * ');
      expect(PdfService.getSafeSeparatorForPdf('-'), '-');
    });
  });
}
