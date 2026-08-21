import 'dart:convert';
import 'package:equatable/equatable.dart';

class PrintHistory extends Equatable {
  final int? id;
  final DateTime createdAt;
  final List<String> chassisNumbers;

  const PrintHistory({
    this.id,
    required this.createdAt,
    required this.chassisNumbers,
  });

  // Convertit l'objet pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'vehicles': jsonEncode(chassisNumbers), // On stocke la liste en texte
    };
  }

  // Recrée l'objet depuis la base de données
  factory PrintHistory.fromMap(Map<String, dynamic> map) {
    return PrintHistory(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      chassisNumbers: List<String>.from(jsonDecode(map['vehicles'])),
    );
  }

  @override
  List<Object?> get props => [id, createdAt, chassisNumbers];
}
