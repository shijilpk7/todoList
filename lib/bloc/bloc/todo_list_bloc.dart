import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:todo_list/data/models/todo.dart';
import 'package:todo_list/data/repository/todo_repository.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final todoListRepository = new TodoRepository();
  TodoListBloc() : super(TodoListState(list: [], action: 'none'));

  @override
  Stream<TodoListState> mapEventToState(
    TodoListEvent event,
  ) async* {
    switch (event) {
      case TodoListEvent.getList:
        final data = await todoListRepository.getList();
        if (data.isNotEmpty) {
          final listData = json.decode(data.toString());
          List<Todo> response = setTodoList(data, 'none');
          yield TodoListState(list: response, action: listData['action']);
        } else {
          yield TodoListState(list: [], action: 'none');
        }

        break;
      case TodoListEvent.getListActive:
        final data = await todoListRepository.getList();
        if (data.isNotEmpty) {
          final listData = json.decode(data.toString());
          List<Todo> response = setTodoList(data, 'active');
          yield TodoListState(list: response, action: listData['action']);
        } else {
          yield TodoListState(list: [], action: 'none');
        }

        break;
      case TodoListEvent.getListCompleted:
        final data = await todoListRepository.getList();
        if (data.isNotEmpty) {
          final listData = json.decode(data.toString());
          List<Todo> response = setTodoList(data, 'completed');
          yield TodoListState(list: response, action: listData['action']);
        } else {
          yield TodoListState(list: [], action: 'none');
        }

        break;
      case TodoListEvent.setMarkedAsCompleted:
        final oldData = await todoListRepository.getList();
        if (oldData.isNotEmpty) {
          List<Todo> responseCompleted = setTodoList(oldData, 'completed');
          List<Todo> latest = [];
          latest.addAll(responseCompleted);
          latest.addAll(state.list);
          state.list = latest;
          final data =
              await todoListRepository.setList(jsonEncode(state.toJson()));
          List<Todo> response = setTodoList(data, 'active');
          yield TodoListState(list: response, action: 'success');
        } else {
          yield TodoListState(list: [], action: 'none');
        }

        break;
      case TodoListEvent.setListActive:
        final oldData = await todoListRepository.getList();
        if (oldData.isNotEmpty) {
          List<Todo> latest = setTodoList(oldData, 'completed');
          latest.addAll(state.list);

          state.list = latest;
          final data =
              await todoListRepository.setList(jsonEncode(state.toJson()));
          List<Todo> response = setTodoList(data, 'active');
          yield TodoListState(list: response, action: 'success');
        } else {
          final data =
              await todoListRepository.setList(jsonEncode(state.toJson()));
          List<Todo> response = setTodoList(data, 'active');
          yield TodoListState(list: response, action: 'success');
        }

        break;
      case TodoListEvent.removeListActive:
        final oldData = await todoListRepository.getList();
        if (oldData.isNotEmpty) {
          List<Todo> responseCompleted = setTodoList(oldData, 'completed');
          List<Todo> responseActive = setTodoList(oldData, 'active');
          List<Todo> latest = [];
          latest.addAll(responseCompleted);
          final newData = state.list;
          for (var i = 0; i < responseActive.length; i++) {
            for (var j = 0; j < newData.length; j++) {
              if (responseActive[i] == newData[j]) {
                latest.add(responseActive[i]);
                break;
              }
            }
          }
          state.list = latest;
          final data =
              await todoListRepository.setList(jsonEncode(state.toJson()));
          List<Todo> response = setTodoList(data, 'active');
          yield TodoListState(list: response, action: 'success');
        } else {
          yield TodoListState(list: [], action: 'none');
        }

        break;
      case TodoListEvent.removeListCompleted:
        final oldData = await todoListRepository.getList();
        if (oldData.isNotEmpty) {
          List<Todo> responseCompleted = setTodoList(oldData, 'completed');
          List<Todo> responseActive = setTodoList(oldData, 'active');
          List<Todo> latest = [];
          latest.addAll(responseActive);
          final newData = state.list;
          for (var i = 0; i < responseCompleted.length; i++) {
            for (var j = 0; j < newData.length; j++) {
              if (responseCompleted[i] == newData[j]) {
                latest.add(responseCompleted[i]);
                break;
              }
            }
          }
          state.list = latest;
          final data =
              await todoListRepository.setList(jsonEncode(state.toJson()));
          List<Todo> response = setTodoList(data, 'completed');
          yield TodoListState(list: response, action: 'success');
        } else {
          yield TodoListState(list: [], action: 'none');
        }

        break;
    }
  }

  List<Todo> setTodoList(dynamic data, String status) {
    final listData = json.decode(data.toString());
    final todo = listData['list'];
    List<Todo> response = [];
    for (var i = 0; i < todo.length; i++) {
      if (todo[i]['status'] == status || status == 'none')
        response.add(new Todo(
          message: todo[i]['message'],
          status: todo[i]['status'],
        ));
    }
    return response;
  }
}
