import 'package:equatable/equatable.dart';
import '../../data/models/vehicle.dart';

class VehicleState extends Equatable {
  final List<Vehicle> vehicles;

  const VehicleState({this.vehicles = const []});

  VehicleState copyWith({List<Vehicle>? vehicles}) {
    return VehicleState(vehicles: vehicles ?? this.vehicles);
  }

  @override
  List<Object> get props => [vehicles];
}
