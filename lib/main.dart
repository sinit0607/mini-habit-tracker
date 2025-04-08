import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_habit_tracker_app/presentation/bloc/habit_bloc.dart';
import 'data/repositories/habit_repository_impl.dart';
import 'domain/repositories/habit_repository.dart';
import 'firebase_options.dart';
import 'presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Use the concrete implementation of the repository
  final habitRepository = HabitRepositoryImpl();

  runApp(MyApp(habitRepository: habitRepository));
}

class MyApp extends StatelessWidget {
  final HabitRepository
  habitRepository; // This still uses the abstract type for the parameter

  const MyApp({super.key, required this.habitRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HabitBloc>(
          create: (context) => HabitBloc(habitRepository),
        ),
        // Add other BlocProviders here if needed
      ],
      child: MaterialApp.router(
        title: 'Mini Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
