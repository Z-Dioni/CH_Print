import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../data/models/vehicle.dart';

class PdfService {
  /// Génère le document PDF à partir de la liste des véhicules
  static Future<Uint8List> generatePdf(List<Vehicle> vehicles) async {
    final pdf = pw.Document();

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
          margin: const pw.EdgeInsets.all(10),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Expanded(child: _buildLabel(chunk[0].chassisNumber)),
                pw.Expanded(child: _buildLabel(chunk[0].chassisNumber)),

                if (chunk.length > 1) ...[
                  pw.Expanded(child: _buildLabel(chunk[1].chassisNumber)),
                  pw.Expanded(child: _buildLabel(chunk[1].chassisNumber)),
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
  static pw.Widget _buildLabel(String chassisNumber) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey400,
          width: 1,
          style: pw.BorderStyle.dashed,
        ),
      ),
      // Marge interne très fine pour coller le texte aux bords
      padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: pw.Center(
        // BoxFit.fill est la clé : il étire le texte en hauteur ET en largeur !
        child: pw.FittedBox(
          fit: pw.BoxFit.fill,
          child: pw.Text(
            'CH * $chassisNumber',
            style: pw.TextStyle(fontSize: 300, fontWeight: pw.FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
