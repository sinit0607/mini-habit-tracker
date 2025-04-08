import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit_entity.dart';

/// Firestore-compatible model that extends the domain HabitEntity.
class HabitModel extends HabitEntity {
  // Make mutable fields here only
  int streak;
  List<DateTime> completedDates;

  HabitModel({
    required String id,
    required String name,
    required String frequency,
    required DateTime startDate,
    required this.streak,
    required this.completedDates,
  }) : super(
    id: id,
    name: name,
    frequency: frequency,
    startDate: startDate,
    streak: streak,
    completedDates: completedDates,
  );

  factory HabitModel.fromMap(String id, Map<String, dynamic> map) {
    return HabitModel(
      id: id,
      name: map['name'] as String,
      frequency: map['frequency'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
      streak: map['streak'] ?? 0,
      completedDates: (map['completedDates'] as List<dynamic>)
          .map((ts) => (ts as Timestamp).toDate())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequency': frequency,
      'startDate': Timestamp.fromDate(startDate),
      'streak': streak,
      'completedDates': completedDates.map((d) => Timestamp.fromDate(d)).toList(),
    };
  }

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      frequency: entity.frequency,
      startDate: entity.startDate,
      streak: entity.streak,
      completedDates: List.from(entity.completedDates),
    );
  }
}
