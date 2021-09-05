part of 'todo_list_bloc.dart';

class TodoListState {
  List<Todo> list;
  String action;
  TodoListState({required this.action, required this.list});

  Map<String, dynamic> toJson() => {
        'list': list,
        'action': action,
      };
}
