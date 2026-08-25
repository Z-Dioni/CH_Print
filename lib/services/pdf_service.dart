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
      // Extraction d'un groupe de 2 véhicules max
      final chunk = vehicles.sublist(
        i,
        i + 2 > vehicles.length ? vehicles.length : i + 2,
      );

      // 2. Création de la page A4 en orientation Portrait
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4, // Format portrait classique
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // Véhicule 1 - Exemplaire 1
                pw.Expanded(child: _buildLabel(chunk[0].chassisNumber)),

                // Véhicule 1 - Exemplaire 2
                pw.Expanded(child: _buildLabel(chunk[0].chassisNumber)),

                // Véhicule 2 (s'il existe dans ce groupe)
                if (chunk.length > 1) ...[
                  // Véhicule 2 - Exemplaire 1
                  pw.Expanded(child: _buildLabel(chunk[1].chassisNumber)),

                  // Véhicule 2 - Exemplaire 2
                  pw.Expanded(child: _buildLabel(chunk[1].chassisNumber)),
                ] else ...[
                  // Espaces vides pour maintenir les bonnes proportions si 1 seul véhicule est présent
                  pw.Expanded(child: pw.Container()),
                  pw.Expanded(child: pw.Container()),
                ],
              ],
            );
          },
        ),
      );
    }

    // Retourne le document sous forme de données binaires
    return pdf.save();
  }

  /// Construit une étiquette individuelle occupant toute la largeur
  static pw.Widget _buildLabel(String chassisNumber) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        // Bordure en pointillés gris léger pour guider le coup de ciseau
        border: pw.Border.all(
          color: PdfColors.grey400,
          width: 1,
          style: pw.BorderStyle.dashed,
        ),
      ),
      padding: const pw.EdgeInsets.all(10), // Légère marge interne
      child: pw.Center(
        // Le FittedBox force le texte à s'étirer au maximum de l'espace disponible
        child: pw.FittedBox(
          fit: pw.BoxFit.contain,
          child: pw.Text(
            'CH * $chassisNumber', // J'ai remplacé le tiret par une étoile comme sur l'image
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
