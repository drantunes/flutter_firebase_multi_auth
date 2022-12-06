import 'package:faker/faker.dart';
import 'package:flutter_firebase_multi_auth/sm/statex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tasksStateProvider = Provider<TasksState>((ref) => TasksState([]));

class TasksState extends StateX<List<String>> {
  TasksState(super.initState);

  add() {
    state = [...state, Faker().lorem.word()];
  }

  remove(int index) {
    state.removeAt(index);
    state = state;
  }
}
