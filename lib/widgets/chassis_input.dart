import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChassisInput extends StatelessWidget {
  final String initialValue;
  final Function(String) onChanged;

  const ChassisInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      maxLength: 4,
      onChanged: onChanged,
      // Filtres pour forcer uniquement les chiffres
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      decoration: const InputDecoration(
        labelText: 'Numéro de châssis',
        hintText: 'Ex: 1234',
        counterText: '', // Cache le compteur "0/4" sous le champ
        prefixIcon: Icon(Icons.directions_car_outlined),
      ),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }
}
