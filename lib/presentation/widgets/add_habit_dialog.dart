import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/habit_entity.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';

class AddHabitDialog extends StatefulWidget {
  final HabitEntity? habitToEdit; // optional for edit

  const AddHabitDialog({super.key, this.habitToEdit});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _frequency = 'daily';
  DateTime _selectedDate = DateTime.now();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    // If editing, populate existing data
    final habit = widget.habitToEdit;
    if (habit != null) {
      isEdit = true;
      _nameController.text = habit.name;
      _frequency = habit.frequency;
      _selectedDate = habit.startDate;
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;

    final id = isEdit ? widget.habitToEdit!.id : const Uuid().v4();

    final habit = HabitEntity(
      id: id,
      name: _nameController.text.trim(),
      frequency: _frequency,
      startDate: _selectedDate,
      streak: isEdit ? widget.habitToEdit!.streak : 0,
      completedDates: isEdit ? widget.habitToEdit!.completedDates : [],
    );

    if (isEdit) {
      context.read<HabitBloc>().add(EditHabitEvent(habit));
    } else {
      context.read<HabitBloc>().add(AddHabitEvent(habit));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit Habit' : 'Add Habit'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Habit Name'),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _frequency,
              onChanged: (value) {
                setState(() => _frequency = value!);
              },
              items: const [
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text('Start Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
