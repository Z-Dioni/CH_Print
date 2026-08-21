import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/vehicle_bloc/vehicle_bloc.dart';
import '../../state/vehicle_bloc/vehicle_event.dart';
import '../../state/vehicle_bloc/vehicle_state.dart';
import '../../widgets/vehicle_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          // En-tête / Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Générez rapidement vos étiquettes de numéros de châssis.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),

          // Liste dynamique des véhicules
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
                      // La clé (Key) est cruciale ici pour que Flutter ne mélange pas
                      // les champs de texte quand on supprime un élément au milieu de la liste
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

          // Bouton Ajouter
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

          // Bouton Générer (Bien visible en bas)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56, // Bouton large et facile à cliquer
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // La validation et la génération seront ajoutées à l'étape 5
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Génération à venir (Étape suivante)'),
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
