import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../state/history_bloc/history_bloc.dart';
import '../../state/history_bloc/history_event.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Apparence',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.brightness_6_outlined),
            title: Text('Thème de l\'application'),
            subtitle: Text(
              'Adapté automatiquement à votre système (Clair/Sombre)',
            ),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Données',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            title: const Text(
              'Effacer l\'historique',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text(
              'Supprime définitivement toutes les générations passées.',
            ),
            onTap: () => _showClearHistoryDialog(context),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'À propos',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          // NOUVEAU : Lien vers tes autres applications
          ListTile(
            leading: const Icon(Icons.apps_outlined, color: Colors.blue),
            title: const Text('Mes autres applications'),
            subtitle: const Text('Découvrir les autres solutions de SoftBox.'),
            trailing: const Icon(
              Icons.open_in_new,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () async {
              // Remplace cette URL par le lien vers ton Play Store ou ton site web
              final Uri url = Uri.parse('https://softbox-siteweb.vercel.app/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Informations sur l\'application'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'CH Print',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.print,
                  size: 48,
                  color: Colors.blueGrey,
                ),
                applicationLegalese:
                    '© ${DateTime.now().year} - Application utilitaire hors ligne pour la gestion des numéros de châssis.',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Effacer l\'historique ?'),
          content: const Text(
            'Cette action est irréversible. Tous vos anciens numéros générés seront perdus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('ANNULER'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
              ),
              onPressed: () {
                context.read<HistoryBloc>().add(ClearAllHistory());
                Navigator.pop(dialogContext);

                // NOUVEAU : Notification moderne et élégante
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Historique effacé avec succès.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.teal.shade600,
                    behavior: SnackBarBehavior
                        .floating, // Rend la notification flottante
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bords arrondis
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    elevation: 4,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('EFFACER'),
            ),
          ],
        );
      },
    );
  }
}
