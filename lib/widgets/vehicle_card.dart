import 'package:flutter/material.dart';
import 'chassis_input.dart';

class VehicleCard extends StatelessWidget {
  final int index;
  final String initialValue;
  final VoidCallback onDelete;
  final Function(String) onChanged;
  final FocusNode? focusNode;

  const VehicleCard({
    super.key,
    required this.index,
    required this.initialValue,
    required this.onDelete,
    required this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.directions_car_rounded,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Véhicule ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Supprimer',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ChassisInput(
              initialValue: initialValue,
              onChanged: onChanged,
              focusNode: focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
