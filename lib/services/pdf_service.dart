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

      // 2. Création de la page A4 en orientation Paysage
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          // Marge de 20 points pour s'assurer que les imprimantes ne coupent pas les bords
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              children: [
                // Ligne 1 : Véhicule 1 (qui crée automatiquement 2 exemplaires)
                pw.Expanded(child: _buildVehicleRow(chunk[0])),

                // Ligne 2 : Véhicule 2 (s'il existe dans ce groupe, sinon on laisse un espace vide)
                pw.Expanded(
                  child: chunk.length > 1
                      ? _buildVehicleRow(chunk[1])
                      : pw.Container(), // Espace vide si nombre de véhicules impair
                ),
              ],
            );
          },
        ),
      );
    }

    // Retourne le document sous forme de données binaires
    return pdf.save();
  }

  /// Construit la ligne contenant les 2 exemplaires (Avant / Arrière) pour un véhicule
  static pw.Widget _buildVehicleRow(Vehicle vehicle) {
    return pw.Row(
      children: [
        // Exemplaire 1 (Moitié gauche)
        pw.Expanded(child: _buildLabel(vehicle.chassisNumber)),

        // Exemplaire 2 (Moitié droite)
        pw.Expanded(child: _buildLabel(vehicle.chassisNumber)),
      ],
    );
  }

  /// Construit une étiquette individuelle avec bordure de découpe
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
      child: pw.Center(
        child: pw.Text(
          'CH - $chassisNumber',
          style: pw.TextStyle(
            fontSize: 85, // Texte très grand
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
