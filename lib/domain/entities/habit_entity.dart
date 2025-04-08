import 'package:equatable/equatable.dart';

/// The core Habit entity used across the app
class HabitEntity extends Equatable {
  final String id;
  final String name;
  final String frequency; // 'daily' or 'weekly'
  final DateTime startDate;
  final int streak;
  final List<DateTime> completedDates;

  const HabitEntity({
    required this.id,
    required this.name,
    required this.frequency,
    required this.startDate,
    required this.streak,
    required this.completedDates,
  });

  @override
  List<Object?> get props => [id, name, frequency, startDate, streak, completedDates];
}
