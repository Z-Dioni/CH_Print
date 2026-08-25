import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comment utiliser CH Print ?')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Carte de la règle métier
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8),
                      Text(
                        'Règle de génération',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Chaque véhicule génère automatiquement deux exemplaires de son numéro : un pour l\'avant et un pour l\'arrière. L\'application regroupe automatiquement 2 véhicules (soit 4 exemplaires) par page A4.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Étapes à suivre :',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Liste des étapes
          _buildStep(
            context,
            '1',
            'Ajoutez un véhicule.',
            Icons.add_circle_outline,
          ),
          _buildStep(
            context,
            '2',
            'Entrez les quatre chiffres.',
            Icons.pin_outlined,
          ),
          _buildStep(
            context,
            '3',
            'Ajoutez les autres véhicules si nécessaire.',
            Icons.library_add_outlined,
          ),
          _buildStep(
            context,
            '4',
            'Appuyez sur "Générer le PDF".',
            Icons.picture_as_pdf_outlined,
          ),
          _buildStep(
            context,
            '5',
            'Vérifiez le document dans l\'aperçu.',
            Icons.preview_outlined,
          ),
          _buildStep(
            context,
            '6',
            'Imprimez ou partagez le PDF.',
            Icons.print_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            child: Text(
              number,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
