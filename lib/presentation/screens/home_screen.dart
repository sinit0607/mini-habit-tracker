import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/habit_repository_impl.dart';
import '../../core/utils/snackbar_util.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../widgets/add_habit_dialog.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide HabitBloc scoped to this screen and load habits initially
      create: (_) => HabitBloc(HabitRepositoryImpl())..add(LoadHabitsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mini Habit Tracker')),

        // Main content based on state
        body: BlocBuilder<HabitBloc, HabitState>(
          builder: (context, state) {
            if (state is HabitLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HabitLoaded) {
              if (state.habits.isEmpty) {
                return const Center(child: Text('No habits yet. Add one!'));
              }

              // Show list of habits
              return ListView.builder(
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  final habit = state.habits[index];
                  final now = DateTime.now();

                  // ✅ Check if the habit is already completed today
                  final isCompletedToday = habit.completedDates.any(
                    (date) =>
                        date.year == now.year &&
                        date.month == now.month &&
                        date.day == now.day,
                  );

                  // ✅ Allow marking complete only if today >= start date
                  final hasStarted =
                      now.isAfter(habit.startDate) ||
                      (now.year == habit.startDate.year &&
                          now.month == habit.startDate.month &&
                          now.day == habit.startDate.day);

                  return ListTile(
                    title: Text(habit.name),
                    subtitle: Text('Streak: ${habit.streak}'),

                    // ✅ Show green icon if completed, else gray
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Check/Done Button
                        IconButton(
                          icon: Icon(
                            isCompletedToday
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color:
                                isCompletedToday
                                    ? Colors.green
                                    : hasStarted
                                    ? Colors.grey
                                    : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            if (!hasStarted) {
                              final formattedDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(habit.startDate);
                              SnackbarUtil.showInstagramStyle(
                                context,
                                '⏳ This habit starts on $formattedDate',
                              );
                              return;
                            }

                            if (!isCompletedToday) {
                              context.read<HabitBloc>().add(
                                CompleteHabitEvent(habit.id),
                              );
                            }
                          },
                        ),

                        // 📝 Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => BlocProvider.value(
                                    value: context.read<HabitBloc>(),
                                    child: AddHabitDialog(
                                      habitToEdit: habit,
                                    ), // pass habit
                                  ),
                            );
                          },
                        ),

                        // 🗑 Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<HabitBloc>().add(
                              DeleteHabitEvent(habit.id),
                            );
                            SnackbarUtil.showInstagramStyle(
                              context,
                              'Habit deleted',
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is HabitError) {
              return const Center(child: Text('Something went wrong.'));
            }

            // Return empty widget for unknown states
            return const SizedBox();
          },
        ),

        // FAB opens the AddHabitDialog
        floatingActionButton: Builder(
          builder: (dialogContext) {
            return FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: dialogContext,
                  builder:
                      (_) => BlocProvider.value(
                        // Pass down the existing HabitBloc instance
                        value: BlocProvider.of<HabitBloc>(context),
                        child: const AddHabitDialog(),
                      ),
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
