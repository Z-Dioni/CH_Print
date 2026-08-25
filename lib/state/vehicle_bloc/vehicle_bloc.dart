import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vehicle.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(const VehicleState()) {
    on<AddVehicle>((event, emit) {
      final newVehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      final updatedList = List<Vehicle>.from(state.vehicles)..add(newVehicle);
      emit(state.copyWith(vehicles: updatedList));
    });

    on<RemoveVehicle>((event, emit) {
      final updatedList = state.vehicles
          .where((v) => v.id != event.id)
          .toList();
      emit(state.copyWith(vehicles: updatedList));
    });

    on<UpdateChassisNumber>((event, emit) {
      final updatedList = state.vehicles.map((v) {
        if (v.id == event.id) {
          return v.copyWith(chassisNumber: event.chassisNumber);
        }
        return v;
      }).toList();
      emit(state.copyWith(vehicles: updatedList));
    });

    on<ResetVehicles>((event, emit) {
      // On crée un nouveau véhicule vide
      final newVehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      // On écrase la liste existante avec uniquement ce nouveau véhicule
      emit(state.copyWith(vehicles: [newVehicle]));
    });
  }
}
