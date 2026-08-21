import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String chassisNumber;

  const Vehicle({required this.id, this.chassisNumber = ''});

  Vehicle copyWith({String? chassisNumber}) {
    return Vehicle(id: id, chassisNumber: chassisNumber ?? this.chassisNumber);
  }

  @override
  List<Object> get props => [id, chassisNumber];
}
