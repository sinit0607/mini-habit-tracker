import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../models/habit_model.dart';

/// Implementation of HabitRepository using Firebase Firestore.
class HabitRepositoryImpl implements HabitRepository {
  final _collection = FirebaseFirestore.instance.collection('habits');

  @override
  Future<void> addHabit(HabitEntity habit) async {
    final model = HabitModel.fromEntity(habit);
    await _collection.doc(habit.id).set(model.toMap());
  }

  @override
  Future<void> markHabitCompleted(String id) async {
    final doc = _collection.doc(id);
    final snapshot = await doc.get();
    if (!snapshot.exists) return;

    final model = HabitModel.fromMap(snapshot.id, snapshot.data()!);
    final now = DateTime.now();

    // Avoid duplicate completions for the same day
    final alreadyCompleted = model.completedDates.any((d) =>
    d.year == now.year && d.month == now.month && d.day == now.day);

    if (!alreadyCompleted) {
      model.completedDates.add(now);
      model.streak += 1;

      await doc.update({
        'completedDates': model.completedDates.map((d) => Timestamp.fromDate(d)).toList(),
        'streak': model.streak,
      });
    }
  }

  @override
  Stream<List<HabitEntity>> getHabits() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
  @override
  Future<void> deleteHabit(String id) async {
    await _collection.doc(id).delete();
  }

  @override
  Future<void> editHabit(HabitEntity habit) async {
    final model = HabitModel.fromEntity(habit);
    await _collection.doc(habit.id).update(model.toMap());
  }
}
