import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import '../../data/models/vehicle.dart';
import '../../services/pdf_service.dart';
import '../../state/vehicle_bloc/vehicle_bloc.dart';
import '../../state/vehicle_bloc/vehicle_event.dart';

class PdfPreviewScreen extends StatelessWidget {
  final List<Vehicle> vehicles;

  const PdfPreviewScreen({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aperçu avant impression'),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.read<VehicleBloc>().add(ResetVehicles());
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('Accueil'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.45),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${vehicles.length} véhicule${vehicles.length > 1 ? 's' : ''} sélectionné${vehicles.length > 1 ? 's' : ''}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Format A4 • Impression et partage disponibles',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: PdfPreview(
                    build: (format) => PdfService.generatePdf(vehicles),
                    allowPrinting: true,
                    allowSharing: true,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    canDebug: false,
                    pdfFileName:
                        'CH_Print_${DateTime.now().millisecondsSinceEpoch}.pdf',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
