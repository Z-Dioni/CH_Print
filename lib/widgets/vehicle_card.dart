import 'package:flutter/material.dart';
import 'chassis_input.dart';

class VehicleCard extends StatelessWidget {
  final int index;
  final String initialValue;
  final VoidCallback onDelete;
  final Function(String) onChanged;

  const VehicleCard({
    super.key,
    required this.index,
    required this.initialValue,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Véhicule ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Supprimer',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ChassisInput(initialValue: initialValue, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
