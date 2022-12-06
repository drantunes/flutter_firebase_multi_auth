import 'package:flutter/material.dart';
import 'package:flutter_firebase_multi_auth/services/auth_service.dart';
import 'package:flutter_firebase_multi_auth/sm/statex_widget.dart';
import 'package:flutter_firebase_multi_auth/states/tasks_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Consumer(builder: (context, ref, _) {
            return IconButton(
              onPressed: ref.read(authServiceProvider).logout,
              icon: const Icon(Icons.logout),
            );
          }),
          IconButton(
            onPressed: () => context.push('/login'),
            icon: const Icon(Icons.abc),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Card(
              child: InkWell(
                onTap: () => context.push('/tasks'),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Consumer(builder: (context, ref, _) {
                    return StateXWidget(
                      state: ref.watch(tasksStateProvider),
                      builder: (List<String> state) => Text(
                        '${state.length} Tarefas',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
