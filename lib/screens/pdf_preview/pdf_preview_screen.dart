import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../data/models/vehicle.dart';
import '../../services/pdf_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final List<Vehicle> vehicles;

  const PdfPreviewScreen({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aperçu avant impression')),
      // PdfPreview est un widget natif du package printing
      body: PdfPreview(
        // On demande à notre PdfService de générer les données binaires
        build: (format) => PdfService.generatePdf(vehicles),

        // Options pour simplifier l'interface de l'utilisateur
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation:
            false, // On bloque l'orientation (toujours Paysage)
        canChangePageFormat: false, // On bloque le format (toujours A4)
        canDebug: false, // Cache le bouton de debug en bas
        pdfFileName: 'CH_Print_${DateTime.now().millisecondsSinceEpoch}.pdf',
      ),
    );
  }
}
