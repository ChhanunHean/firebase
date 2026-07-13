import 'package:flutter/material.dart';

import '../../../data/repository/repository_exception.dart';

import '../../../data/repository/todo_repository.dart';
import '../../../models/todo.dart';
import '../../theme/app_screen.dart';
import '../../utils/async_data.dart';
import 'todo_card.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  AsyncData<List<Todo>> asyncData = AsyncData.notstarted();

  @override
  void initState() {
    super.initState();

    // Fetch todos on init state
    _fetchTodos();
  }

  void _fetchTodos() async {
    TodoRepository repository = TodoRepository.global;
    //----------------------------------------------------------------------------
    //                                step 1
    // i fect data from TodoRepository class in file todo_repository
    //----------------------------------------------------------------------------
    // ------------------------- fect data ---------------------------------------
    setState(() {
      asyncData = AsyncData.loading();
    });

    try {
      List<Todo> todos = await repository.getTodos();
      setState(() {
        asyncData = AsyncData.success(todos);
      });
    } on RepositoryException catch (e) {
      setState(() {
        asyncData = AsyncData.error(e.message);
      });
    }
    // ---------------------------------------------------------------------------
  }

  void onUpdateCompleted(Todo todo) async {
    TodoRepository repository = TodoRepository.global;
    //------------------------------------------------------------------------------------
    //                                        Step 5
    //------------------------------------------------------------------------------------
    // final updatedTodo = todo.copyWith(!todo.completed); // after teacher ask me and want me to change it now i back to the old method this method just selt study to understand more
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      completed: !todo.completed
    );
    final updatedList = asyncData.value!
        .map((t) => t.id == todo.id ? updatedTodo : t)
        .toList();
    setState(() => asyncData = AsyncData.success(updatedList));

    try {
      await repository.updateCompleted(todo.id, !todo.completed);
    } on RepositoryException catch (e) {
      setState(() => asyncData = AsyncData.error(e.message));
    }
    //------------------------------------------------------------------------------------
  }

  Widget get content => switch (asyncData.status) {
    AsyncStatus.notstarted => Text(
      "Tap to refresh",
      style: AppTheme.paragraph.copyWith(color: AppTheme.redColor),
    ),

    AsyncStatus.loading => CircularProgressIndicator(),

    AsyncStatus.success => _buildTodos(),

    AsyncStatus.error => _buildError(),
  };

  Widget _buildTodos() {
    List<Todo> todos = asyncData.value!;
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) =>
          TodoCard(todo: todos[index], onTap: onUpdateCompleted),
    );
  }

  Widget _buildError() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning, color: AppTheme.redColor),
        SizedBox(width: 10),

        Text(
          asyncData.error!,
          style: AppTheme.paragraph.copyWith(color: AppTheme.redColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: Text("Welcome !", style: AppTheme.heading),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: content),
      ),
    );
  }
}
