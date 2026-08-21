import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {}

class AddToHistory extends HistoryEvent {
  final List<String> chassisNumbers;
  const AddToHistory(this.chassisNumbers);
  @override
  List<Object> get props => [chassisNumbers];
}

class RemoveFromHistory extends HistoryEvent {
  final int id;
  const RemoveFromHistory(this.id);
  @override
  List<Object> get props => [id];
}
