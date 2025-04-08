import '../entities/habit_entity.dart';

/// Abstract contract for habit-related operations.
/// This ensures the domain layer is decoupled from Firebase or other data sources.
abstract class HabitRepository {
  /// Add a new habit to the data source
  Future<void> addHabit(HabitEntity habit);

  /// Mark a habit as completed (today)
  Future<void> markHabitCompleted(String id);

  /// Stream a list of all habits in real-time
  Stream<List<HabitEntity>> getHabits();
  /// edit habit to the data source
  Future<void> deleteHabit(String id);
  /// delete habit to the data source
  Future<void> editHabit(HabitEntity habit);

}
