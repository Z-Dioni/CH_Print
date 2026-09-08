import 'package:ch_print/screens/pdf_preview/pdf_preview_screen.dart';
import 'package:ch_print/state/history_bloc/history_bloc.dart';
import 'package:ch_print/state/history_bloc/history_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/vehicle_bloc/vehicle_bloc.dart';
import '../../state/vehicle_bloc/vehicle_event.dart';
import '../../state/vehicle_bloc/vehicle_state.dart';
import '../../widgets/vehicle_card.dart';
import '../../core/utils/validators.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void dispose() {
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<VehicleBloc, VehicleState>(
      builder: (context, state) {
        final vehicles = state.vehicles;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.print_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CH Print',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Génération rapide d’étiquettes de châssis',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Véhicules',
                          value: '${vehicles.length}',
                          icon: Icons.directions_car_rounded,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Format',
                          value: 'A4',
                          icon: Icons.article_rounded,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Liste des véhicules',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: vehicles.isEmpty
                        ? Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.format_list_bulleted_rounded,
                                    size: 48,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Aucun véhicule pour le moment',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ajoutez un véhicule pour commencer la génération.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: vehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = vehicles[index];
                              return VehicleCard(
                                key: ValueKey(vehicle.id),
                                index: index,
                                initialValue: vehicle.chassisNumber,
                                focusNode: _focusNodes.putIfAbsent(
                                  vehicle.id,
                                  FocusNode.new,
                                ),
                                onChanged: (value) {
                                  context.read<VehicleBloc>().add(
                                    UpdateChassisNumber(vehicle.id, value),
                                  );
                                },
                                onDelete: () {
                                  _focusNodes.remove(vehicle.id)?.dispose();
                                  context.read<VehicleBloc>().add(
                                    RemoveVehicle(vehicle.id),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<VehicleBloc>().add(AddVehicle());
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          final updatedVehicles = context
                              .read<VehicleBloc>()
                              .state
                              .vehicles;
                          if (updatedVehicles.isNotEmpty) {
                            _focusNodes[updatedVehicles.last.id]
                                ?.requestFocus();
                          }
                        });
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Ajouter un véhicule'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.picture_as_pdf_rounded),
                        label: const Text(
                          'GÉNÉRER LE PDF',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          final currentVehicles = context
                              .read<VehicleBloc>()
                              .state
                              .vehicles;

                          if (currentVehicles.isEmpty) {
                            _showError(
                              context,
                              'Ajoutez au moins un véhicule.',
                            );
                            return;
                          }

                          bool hasError = false;
                          for (var vehicle in currentVehicles) {
                            if (!Validators.isValidChassis(
                              vehicle.chassisNumber,
                            )) {
                              hasError = true;
                              break;
                            }
                          }

                          if (hasError) {
                            _showError(
                              context,
                              'Veuillez saisir exactement 4 chiffres pour chaque véhicule.',
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Validation réussie ! Préparation du document...',
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(16),
                            ),
                          );

                          FocusScope.of(context).unfocus();
                          final chassisList = currentVehicles
                              .map((v) => v.chassisNumber)
                              .toList();
                          context.read<HistoryBloc>().add(
                            AddToHistory(chassisList),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PdfPreviewScreen(vehicles: currentVehicles),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
