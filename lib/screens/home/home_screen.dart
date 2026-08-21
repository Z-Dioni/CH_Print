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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fonction pour afficher un message d'erreur
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CH Print',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Générez rapidement vos étiquettes de numéros de châssis.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),

          Expanded(
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state.vehicles.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun véhicule.\nAppuyez sur "Ajouter un véhicule".',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: state.vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = state.vehicles[index];
                    return VehicleCard(
                      key: ValueKey(vehicle.id),
                      index: index,
                      initialValue: vehicle.chassisNumber,
                      onChanged: (value) {
                        context.read<VehicleBloc>().add(
                          UpdateChassisNumber(vehicle.id, value),
                        );
                      },
                      onDelete: () {
                        context.read<VehicleBloc>().add(
                          RemoveVehicle(vehicle.id),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton.icon(
              onPressed: () {
                context.read<VehicleBloc>().add(AddVehicle());
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un véhicule'),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // 1. Récupération de l'état actuel de la liste
                    final vehicles = context.read<VehicleBloc>().state.vehicles;

                    // 2. Validation 1 : La liste est-elle vide ?
                    if (vehicles.isEmpty) {
                      _showError(context, 'Ajoutez au moins un véhicule.');
                      return;
                    }

                    // 3. Validation 2 : Chaque numéro est-il valide ?
                    bool hasError = false;
                    for (var vehicle in vehicles) {
                      if (!Validators.isValidChassis(vehicle.chassisNumber)) {
                        hasError = true;
                        break; // On arrête la boucle dès qu'on trouve une erreur
                      }
                    }

                    if (hasError) {
                      _showError(
                        context,
                        'Veuillez saisir exactement 4 chiffres pour chaque véhicule.',
                      );
                      return;
                    }

                    // 4. Succès : Prêt pour l'aperçu PDF !
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Validation réussie ! Préparation du document...',
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    FocusScope.of(context).unfocus();
                    final chassisList = vehicles
                        .map((v) => v.chassisNumber)
                        .toList();
                    context.read<HistoryBloc>().add(AddToHistory(chassisList));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PdfPreviewScreen(vehicles: vehicles),
                      ),
                    );
                  },
                  child: const Text(
                    'GÉNÉRER LE PDF',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
