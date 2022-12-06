import 'package:flutter/material.dart';
import 'package:flutter_firebase_multi_auth/sm/statex_widget.dart';
import 'package:flutter_firebase_multi_auth/states/tasks_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  addTask(TasksState tasksState) {
    tasksState.add();
  }

  removeTask(TasksState tasksState, int index) {
    tasksState.remove(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final tasksState = ref.watch(tasksStateProvider);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
          actions: [
            IconButton(
              onPressed: () => addTask(tasksState),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: StateXWidget(
          state: tasksState,
          builder: (List<String> state) => ListView.separated(
            itemCount: state.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(state[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => removeTask(tasksState, index),
              ),
            ),
            separatorBuilder: (_, __) => Divider(
              color: Theme.of(context).dividerColor.withOpacity(.5),
              thickness: .2,
            ),
          ),
        ),
      );
    });
  }
}
