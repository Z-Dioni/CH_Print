import 'package:ch_print/state/vehicle_bloc/vehicle_bloc.dart';
import 'package:ch_print/state/vehicle_bloc/vehicle_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import '../../data/models/vehicle.dart';
import '../../services/pdf_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  final List<Vehicle> vehicles;

  const PdfPreviewScreen({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aperçu avant impression'),
        actions: [
          // Nouveau bouton pour retourner directement au dashboard
          TextButton.icon(
            onPressed: () {
              // 1. On réinitialise les champs de saisie
              context.read<VehicleBloc>().add(ResetVehicles());

              // 2. On retourne à l'écran d'accueil
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('Accueil'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8), // Petite marge à droite
        ],
      ),
      body: PdfPreview(
        build: (format) => PdfService.generatePdf(vehicles),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: 'CH_Print_${DateTime.now().millisecondsSinceEpoch}.pdf',
      ),
    );
  }
}
