import 'package:equatable/equatable.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object> get props => [];
}

class AddVehicle extends VehicleEvent {}

class RemoveVehicle extends VehicleEvent {
  final String id;
  const RemoveVehicle(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateChassisNumber extends VehicleEvent {
  final String id;
  final String chassisNumber;

  const UpdateChassisNumber(this.id, this.chassisNumber);

  @override
  List<Object> get props => [id, chassisNumber];
}
