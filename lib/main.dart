import 'package:ch_print/state/history_bloc/history_bloc.dart';
import 'package:ch_print/state/history_bloc/history_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'state/vehicle_bloc/vehicle_bloc.dart';
import 'state/vehicle_bloc/vehicle_event.dart';
import 'state/theme_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController()..load(),
      child: const CHPrintApp(),
    ),
  );
}

class CHPrintApp extends StatelessWidget {
  const CHPrintApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider nous permettra d'ajouter l'HistoryBloc plus tard
    return MultiBlocProvider(
      providers: [
        BlocProvider<VehicleBloc>(
          create: (context) => VehicleBloc()..add(AddVehicle()),
        ),
        BlocProvider<HistoryBloc>(
          // On charge l'historique dès l'ouverture de l'application
          create: (context) => HistoryBloc()..add(LoadHistory()),
        ),
      ],
      child: MaterialApp(
        title: 'CH Print',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: context.watch<ThemeController>().themeMode,
        home: const MainScreen(),
      ),
    );
  }
}
