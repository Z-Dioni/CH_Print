import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/pdf_service.dart';

class LabelSettingsScreen extends StatefulWidget {
  const LabelSettingsScreen({super.key});

  @override
  State<LabelSettingsScreen> createState() => _LabelSettingsScreenState();
}

class _LabelSettingsScreenState extends State<LabelSettingsScreen> {
  final TextEditingController _separatorController = TextEditingController();
  String _font = PdfService.defaultFont;
  bool _isLoading = true;
  bool _isSaving = false;

  static const List<String> _presetSeparators = [
    '±',
    '-',
    '+',
    '*',
    '✨',
    '•',
    '🇲🇦',
    '🇲🇱',
    '🇹🇳',
    '🇸🇳',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _separatorController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFont = prefs.getString('ch_print_label_font');
    final savedSeparator =
        prefs.getString('ch_print_label_separator') ??
        PdfService.defaultSeparator;

    if (!mounted) return;
    setState(() {
      _font = PdfService.availableFonts.contains(savedFont)
          ? savedFont!
          : PdfService.defaultFont;
      _separatorController.text = savedSeparator;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final separator = _separatorController.text.trim().isEmpty
        ? PdfService.defaultSeparator
        : _separatorController.text;

    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ch_print_label_separator', separator);
    await prefs.setString('ch_print_label_font', _font);

    if (!mounted) return;
    setState(() => _isSaving = false);
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colorScheme.inverseSurface,
          elevation: 6,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: colorScheme.onInverseSurface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Modifications sauvegardées',
                  style: TextStyle(
                    color: colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Format des étiquettes')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Text(
              'Police d’écriture',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les trois choix sont conçus pour rester très lisibles en grande taille et sont imprimés en gras.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: PdfService.availableFonts
                  .map(
                    (font) =>
                        ButtonSegment<String>(value: font, label: Text(font)),
                  )
                  .toList(),
              selected: {_font},
              onSelectionChanged: (selection) {
                setState(() => _font = selection.first);
              },
            ),
            const SizedBox(height: 28),
            Text(
              'Séparateur entre CH et le numéro',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _separatorController,
              maxLength: 4,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Ex : -, +, ✨',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetSeparators.map((preset) {
                final label = preset == ' * ' ? 'Espace' : preset;
                return ChoiceChip(
                  label: Text(label),
                  selected: _separatorController.text == preset,
                  onSelected: (_) {
                    setState(() => _separatorController.text = preset);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Aperçu : CH${_separatorController.text}1234',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveSettings,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_rounded),
                label: const Text('SAUVEGARDER'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
