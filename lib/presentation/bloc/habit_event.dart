import 'package:equatable/equatable.dart';
import '../../domain/entities/habit_entity.dart';

/// Abstract base class for all habit-related events
abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

/// Load all habits from Firestore
class LoadHabitsEvent extends HabitEvent {}

/// Add a new habit
class AddHabitEvent extends HabitEvent {
  final HabitEntity habit;

  const AddHabitEvent(this.habit);

  @override
  List<Object?> get props => [habit];
}

/// Mark a habit as completed for today
class CompleteHabitEvent extends HabitEvent {
  final String id;

  const CompleteHabitEvent(this.id);

  @override
  List<Object?> get props => [id];
}
/// Delete an existing habit
class DeleteHabitEvent extends HabitEvent {
  final String habitId;

  const DeleteHabitEvent(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

/// Edit an existing habit
class EditHabitEvent extends HabitEvent {
  final HabitEntity updatedHabit;

  const EditHabitEvent(this.updatedHabit);

  @override
  List<Object?> get props => [updatedHabit];
}
