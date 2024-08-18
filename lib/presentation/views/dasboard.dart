import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbanku/presentation/blocs/kanban_bloc.dart';
import 'package:kanbanku/presentation/widgets/categorycolumn.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanbanCubit, KanbanState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Kanban App'),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  context.read<KanbanCubit>().logout();
                },
              ),
            ],
          ),
          body: state.error != null
              ? Center(child: Text(state.error!))
              : ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...state.categories.map((category) => CategoryColumn(
                          category: category,
                          tasks: state.tasks
                              .where((task) => task.categoryId == category.id)
                              .toList(),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        _showAddCategoryDialog(context);
                      },
                      child: Text('Add Category'),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Category'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context.read<KanbanCubit>().createCategory(_controller.text);
                  Navigator.pop(context);
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