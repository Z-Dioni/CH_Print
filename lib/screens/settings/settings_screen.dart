import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'label_settings_screen.dart';
import '../../state/history_bloc/history_bloc.dart';
import '../../state/history_bloc/history_event.dart';
import '../../state/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const appVersion = '1.2.0';

  String _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Clair',
      ThemeMode.dark => 'Sombre',
      ThemeMode.system => 'Automatique selon le système',
    };
  }

  void _showThemeDialog(BuildContext context) {
    final controller = context.read<ThemeController>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mode du thème'),
        content: RadioGroup<ThemeMode>(
          groupValue: controller.themeMode,
          onChanged: (mode) {
            if (mode == null) return;
            controller.setThemeMode(mode);
            Navigator.pop(dialogContext);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                title: Text('Automatique'),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                title: Text('Clair'),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                title: Text('Sombre'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = context.watch<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Card(
              elevation: 0,
              color: theme.colorScheme.primaryContainer.withOpacity(0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(18),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.print_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                title: Text(
                  'CH Print',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Version 1.2.0 • Fonctionnement hors ligne',
                ),
              ),
            ),
            const SizedBox(height: 20),
            _SettingsSection(
              title: 'Apparence',
              children: [
                _SettingsTile(
                  icon: Icons.brightness_6_rounded,
                  iconColor: Colors.amber,
                  title: 'Thème de l’application',
                  subtitle: _themeLabel(themeController.themeMode),
                  onTap: () => _showThemeDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.text_fields_rounded,
                  iconColor: Colors.indigo,
                  title: 'Format des étiquettes',
                  subtitle: 'Modifier la police et le séparateur imprimés.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LabelSettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              title: 'Données',
              children: [
                _SettingsTile(
                  icon: Icons.delete_forever_rounded,
                  iconColor: Colors.red,
                  title: 'Effacer l’historique',
                  subtitle:
                      'Supprime définitivement toutes les générations passées.',
                  onTap: () => _showClearHistoryDialog(context),
                  danger: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              title: 'Support',
              children: [
                _SettingsTile(
                  icon: Icons.apps_rounded,
                  iconColor: Colors.blue,
                  title: 'Mes autres applications',
                  subtitle: 'Découvrir les autres solutions de SoftBox.',
                  onTap: () async {
                    final Uri url = Uri.parse(
                      'https://softbox-siteweb.vercel.app/',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: Colors.grey,
                  title: 'Informations sur l’application',
                  subtitle: 'Détails de la version et de l’utilisation.',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CH Print',
                      applicationVersion: appVersion,
                      applicationIcon: const Icon(
                        Icons.print_rounded,
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
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Effacer l’historique ?'),
          content: const Text(
            'Cette action est irréversible. Tous vos anciens numéros générés seront perdus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('ANNULER'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                context.read<HistoryBloc>().add(ClearAllHistory());
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Historique effacé avec succès.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.teal.shade600,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final textColor = danger ? Colors.red : null;

    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: (danger ? Colors.red : iconColor).withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: danger ? Colors.red : iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: textColor?.withOpacity(0.8) ?? null),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right_rounded,
              color:
                  textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
      onTap: onTap,
    );
  }
}
