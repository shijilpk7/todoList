import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:todo_list/data/models/todo.dart';
import 'package:todo_list/data/repository/todo_repository.dart';
import 'package:todo_list/provider/todo_list_state.dart';

class TodoListProvider extends ChangeNotifier {
  final todoListRepository = new TodoRepository();

  TodoListState state = TodoListState(list: [], action: 'none');

  getList() async {
    try {
      final data = await todoListRepository.getList();
      if (data.isNotEmpty) {
        final listData = json.decode(data.toString());
        List<Todo> response = setTodoList(data, 'none');
        this.state.list = response;
        this.state.action = listData['action'];
        notifyListeners();
      } else {
        this.state = TodoListState(list: [], action: 'none');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getListActive() async {
    try {
      final data = await todoListRepository.getList();
      if (data.isNotEmpty) {
        final listData = json.decode(data.toString());
        List<Todo> response = setTodoList(data, 'active');
        this.state.list = response;
        this.state.action = listData['action'];
        notifyListeners();
      } else {
        this.state = TodoListState(list: [], action: 'none');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getListCompleted() async {
    try {
      final data = await todoListRepository.getList();
      if (data.isNotEmpty) {
        final listData = json.decode(data.toString());
        List<Todo> response = setTodoList(data, 'completed');
        this.state.list = response;
        this.state.action = listData['action'];
        notifyListeners();
      } else {
        this.state = TodoListState(list: [], action: 'none');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  setmarkedAsCompleted() async {
    try {
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
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      } else {
        this.state = TodoListState(list: [], action: 'none');
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  setListActive() async {
    try {
      final oldData = await todoListRepository.getList();
      if (oldData.isNotEmpty) {
        List<Todo> latest = setTodoList(oldData, 'completed');
        latest.addAll(state.list);

        state.list = latest;
        final data =
            await todoListRepository.setList(jsonEncode(state.toJson()));
        List<Todo> response = setTodoList(data, 'active');
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      } else {
        final data =
            await todoListRepository.setList(jsonEncode(state.toJson()));
        List<Todo> response = setTodoList(data, 'active');
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  setListActiveFromComplete() async {
    try {
      final oldData = await todoListRepository.getList();
      if (oldData.isNotEmpty) {
        List<Todo> latest = setTodoList(oldData, 'active');
        latest.addAll(state.list);

        state.list = latest;
        final data =
            await todoListRepository.setList(jsonEncode(state.toJson()));
        List<Todo> response = setTodoList(data, 'completed');
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      } else {
        final data =
            await todoListRepository.setList(jsonEncode(state.toJson()));
        List<Todo> response = setTodoList(data, 'active');
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  removeListActive() async {
    try {
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
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      } else {
        this.state = TodoListState(list: [], action: 'none');
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  removeListCompleted() async {
    try {
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
        this.state.list = latest;
        final data =
            await todoListRepository.setList(jsonEncode(state.toJson()));
        List<Todo> response = setTodoList(data, 'completed');
        this.state.list = response;
        this.state.action = 'success';
        notifyListeners();
      } else {
        this.state = TodoListState(list: [], action: 'none');
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
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
