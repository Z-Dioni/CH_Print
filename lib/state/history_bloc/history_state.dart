import 'package:equatable/equatable.dart';
import '../../data/models/print_history.dart';

class HistoryState extends Equatable {
  final List<PrintHistory> histories;

  const HistoryState({this.histories = const []});

  @override
  List<Object> get props => [histories];
}
