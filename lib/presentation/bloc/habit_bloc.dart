import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import 'habit_event.dart';
import 'habit_state.dart';

/// Bloc that manages habit-related state and events.
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository repository;

  HabitBloc(this.repository) : super(HabitInitial()) {
    on<LoadHabitsEvent>(_onLoadHabits);
    on<AddHabitEvent>(_onAddHabit);
    on<CompleteHabitEvent>(_onCompleteHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<EditHabitEvent>(_onEditHabit);

  }

  Future<void> _onLoadHabits(
      LoadHabitsEvent event,
      Emitter<HabitState> emit,
      ) async {
    emit(HabitLoading());
    try {
      await emit.forEach<List<HabitEntity>>(
        repository.getHabits(),
        onData: (habits) => HabitLoaded(habits: habits),
        onError: (_, __) => HabitError(),
      );
    } catch (e) {
      emit(HabitError());
    }
  }

  Future<void> _onAddHabit(
      AddHabitEvent event,
      Emitter<HabitState> emit,
      ) async {
    try {
      await repository.addHabit(event.habit);
    } catch (e) {
      emit(HabitError());
    }
  }

  Future<void> _onCompleteHabit(
      CompleteHabitEvent event,
      Emitter<HabitState> emit,
      ) async {
    try {
      await repository.markHabitCompleted(event.id);
    } catch (e) {
      emit(HabitError());
    }
  }

  Future<void> _onDeleteHabit(
      DeleteHabitEvent event,
      Emitter<HabitState> emit,
      ) async {
    try {
      await repository.deleteHabit(event.habitId);
    } catch (e) {
      emit(HabitError());
    }
  }

  Future<void> _onEditHabit(
      EditHabitEvent event,
      Emitter<HabitState> emit,
      ) async {
    try {
      await repository.editHabit(event.updatedHabit);
    } catch (e) {
      emit(HabitError());
    }
  }

}
