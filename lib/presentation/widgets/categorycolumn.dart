import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbanku/data/models/category.dart';
import 'package:kanbanku/data/models/task.dart';
import 'package:kanbanku/presentation/blocs/kanban_bloc.dart';
import 'package:kanbanku/presentation/widgets/taskcard.dart';
// import '../models/category.dart';
// import '../models/task.dart';
// import '../widgets/task_card.dart';

class CategoryColumn extends StatelessWidget {
  final Category category;
  final List<Task> tasks;

  CategoryColumn({required this.category, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(category.type,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                print('=============================Building task card for ${tasks[index]}'); // Tambahkan log ini
                return TaskCard(task: tasks[index]);
              },
              
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddTaskDialog(context);
            },
            child: Text('Add Task'),
          ),
        ],
      ),
    );
  }

 void _showAddTaskDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {  // Gunakan konteks dialog yang baru
      final TextEditingController _titleController = TextEditingController();
      final TextEditingController _descriptionController = TextEditingController();
      return AlertDialog(
        title: Text('Add Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),  // Gunakan konteks dialog
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                Navigator.of(dialogContext).pop();  // Tutup dialog sebelum membuat tugas
                await context.read<KanbanCubit>().createTask(
                  _titleController.text,
                  _descriptionController.text,
                  category.id,
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}
}
