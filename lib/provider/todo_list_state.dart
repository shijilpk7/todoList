import 'package:todo_list/data/models/todo.dart';

class TodoListState {
  List<Todo> list;
  String action;

  get getList => this.list;

  set setList(list) => this.list = list;

  get getAction => this.action;

  set setAction(action) => this.action = action;
  TodoListState({required this.action, required this.list});

  Map<String, dynamic> toJson() => {
        'list': list,
        'action': action,
      };
}
