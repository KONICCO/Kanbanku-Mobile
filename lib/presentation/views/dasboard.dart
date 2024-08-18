import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanbanku/presentation/blocs/kanban_bloc.dart';
import 'package:kanbanku/presentation/widgets/categorycolumn.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<KanbanCubit, KanbanState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      child: BlocBuilder<KanbanCubit, KanbanState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Kanban App'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => context.read<KanbanCubit>().loadData(),
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => context.read<KanbanCubit>().logout(),
                ),
              ],
            ),
            body: state.error != null
                ? Center(child: Text(state.error!))
                : _buildKanbanBoard(context, state),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddCategoryDialog(context),
              child: Icon(Icons.add),
              tooltip: 'Add Category',
            ),
          );
        },
      ),
    );
  }

  Widget _buildKanbanBoard(BuildContext context, KanbanState state) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        ...state.categories.map((category) {
          final categoryTasks = state.tasks
              .where((task) => task.categoryId == category.id)
              .toList();
          print('Category ${category.type} (ID: ${category.id}) has ${categoryTasks.length} tasks');
          return CategoryColumn(
            category: category,
            tasks: categoryTasks,
          );
        }),
      ],
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
