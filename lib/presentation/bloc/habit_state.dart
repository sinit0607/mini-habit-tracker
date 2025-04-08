import 'package:equatable/equatable.dart';
import '../../domain/entities/habit_entity.dart';

/// Abstract base class for all states emitted by the HabitBloc
abstract class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object?> get props => [];
}

/// Initial state before anything is loaded
class HabitInitial extends HabitState {}

/// Loading state while fetching data
class HabitLoading extends HabitState {}

/// Loaded state with list of habits
class HabitLoaded extends HabitState {
  final List<HabitEntity> habits;

  const HabitLoaded({required this.habits});

  @override
  List<Object?> get props => [habits];
}

/// Error state
class HabitError extends HabitState {}
