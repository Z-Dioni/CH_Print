import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/database/db_helper.dart';
import '../../data/models/print_history.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryState()) {
    on<LoadHistory>((event, emit) async {
      final histories = await DbHelper.instance.getAllHistory();
      emit(HistoryState(histories: histories));
    });

    on<AddToHistory>((event, emit) async {
      final newHistory = PrintHistory(
        createdAt: DateTime.now(),
        chassisNumbers: event.chassisNumbers,
      );
      await DbHelper.instance.insertHistory(newHistory);
      // On recharge la liste après l'ajout
      add(LoadHistory());
    });

    on<RemoveFromHistory>((event, emit) async {
      await DbHelper.instance.deleteHistory(event.id);
      add(LoadHistory());
    });

    on<ClearAllHistory>((event, emit) async {
      await DbHelper.instance
          .clearAllHistory(); // Assure-toi que cette méthode existe dans ton DbHelper
      add(LoadHistory()); // Recharge la liste (qui sera vide)
    });
  }
}
