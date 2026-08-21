import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../state/history_bloc/history_bloc.dart';
import '../../state/history_bloc/history_event.dart';
import '../../state/history_bloc/history_state.dart';
import '../../data/models/vehicle.dart';
import '../pdf_preview/pdf_preview_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.histories.isEmpty) {
            return Center(
              child: Text(
                'Aucun historique pour le moment.',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.histories.length,
            itemBuilder: (context, index) {
              final history = state.histories[index];
              // Formatage simple de la date (ex: 21/08/2026 14:30)
              final dateFormatted = DateFormat(
                'dd/MM/yyyy HH:mm',
              ).format(history.createdAt);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    dateFormatted,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${history.chassisNumbers.length} véhicule(s)',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        color: Theme.of(context).colorScheme.primary,
                        tooltip: 'Voir et imprimer',
                        onPressed: () {
                          // On recrée la liste d'objets Vehicle attendue par PdfPreviewScreen
                          final vehicles = history.chassisNumbers
                              .map((num) => Vehicle(id: '', chassisNumber: num))
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PdfPreviewScreen(vehicles: vehicles),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        tooltip: 'Supprimer',
                        onPressed: () {
                          context.read<HistoryBloc>().add(
                            RemoveFromHistory(history.id!),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
