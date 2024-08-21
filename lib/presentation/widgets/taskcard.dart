import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbanku/data/models/task.dart';
import 'package:kanbanku/presentation/blocs/kanban_bloc.dart';
// import '../models/task.dart';
// import '../blocs/kanban_cubit.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(
          //   width: 2.0, // Ketebalan border
          // ),
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(255, 255, 255, 255), // from-blue-200
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(task.description.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      context
                          .read<KanbanCubit>()
                          .updateTaskCategory(task.id, task.categoryId, false);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      context
                          .read<KanbanCubit>()
                          .updateTaskCategory(task.id, task.categoryId, true);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<KanbanCubit>().deleteTask(task.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
