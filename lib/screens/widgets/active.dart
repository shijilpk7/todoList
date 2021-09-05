import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/bloc/todo_list_bloc.dart';
import 'package:todo_list/data/models/todo.dart';

class ActiveScreen extends StatefulWidget {
  const ActiveScreen({Key? key}) : super(key: key);

  @override
  _ActiveScreenState createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  List<Map<String, dynamic>> isCheckedList = [];
  List<Todo> todoList = [];
  bool editMode = false;
  bool checkedMode = false;
  var len = 0;
  TextEditingController addList = TextEditingController();
  @override
  void initState() {
    BlocProvider.of<TodoListBloc>(context).stream.listen((event) {
      isCheckedList = [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(builder: (context, state) {
      todoList = state.list;
      len = todoList.length;
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        child: Stack(
          children: [
            Container(
              margin: (!editMode)
                  ? EdgeInsets.only(bottom: 50)
                  : EdgeInsets.only(bottom: 0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Map<String, dynamic> temp = {
                    'id': 'id' + index.toString(),
                    'checkBox': false,
                    'edit': false,
                    'text': TextEditingController(
                        text: todoList[index].getMessage.toString()),
                    'prevText': TextEditingController(
                            text: todoList[index].getMessage.toString())
                        .text
                  };
                  isCheckedList.add(temp);
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      // height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isCheckedList[index]['checkBox'],
                            onChanged: (value) {
                              isCheckedList[index]['checkBox'] = value ?? false;
                              editMode = false;
                              var i = 0;
                              if (isCheckedList
                                      .where((element) =>
                                          element['checkBox'] == true)
                                      .length >
                                  0)
                                checkedMode = true;
                              else
                                checkedMode = false;
                              isCheckedList.forEach((element) {
                                isCheckedList[i]['edit'] = false;

                                isCheckedList[i]['text'].text =
                                    isCheckedList[i]['prevText'];
                                i++;
                              });
                              setState(() {});
                            },
                          ),
                          Wrap(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 10),
                                width: MediaQuery.of(context).size.width * .54,
                                child: (isCheckedList[index]['edit'] == false)
                                    ? Text(
                                        todoList[index]
                                            .getMessage
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )
                                    : TextField(
                                        controller: isCheckedList[index]
                                            ['text'],
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        textInputAction:
                                            TextInputAction.newline,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter todo list'),
                                      ),
                              ),
                            ],
                          ),
                          Container(
                            child: IconButton(
                              icon: (isCheckedList[index]['edit'] == false)
                                  ? Icon(Icons.edit)
                                  : Icon(Icons.save),
                              onPressed: () {
                                var i = 0;
                                checkedMode = false;

                                isCheckedList.forEach((element) {
                                  isCheckedList[i]['edit'] = false;
                                  isCheckedList[i]['checkBox'] = false;
                                  i++;
                                });
                                if (editMode) {
                                  editMode = false;
                                  isCheckedList[index]['prevText'] =
                                      isCheckedList[index]['text'].text;
                                } else {
                                  editMode = true;
                                  isCheckedList[index]['edit'] = true;
                                }

                                todoList[index].setMessage(
                                    isCheckedList[index]['text'].text);
                                setState(() {});
                              },
                            ),
                          ),
                          (isCheckedList[index]['edit'] == true)
                              ? Container(
                                  child: IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      var i = 0;
                                      checkedMode = false;
                                      isCheckedList.forEach((element) {
                                        isCheckedList[i++]['edit'] = false;
                                      });
                                      editMode = false;

                                      todoList[index].setMessage(
                                          isCheckedList[index]['prevText']);
                                      isCheckedList[index]['text'].text =
                                          isCheckedList[index]['prevText'];
                                      setState(() {});
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: todoList.length,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: (!editMode)
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.blue),
                              ),
                              onPressed: () {
                                if (checkedMode) {
                                  for (var i = 0; i < todoList.length; i++) {
                                    if (isCheckedList[i]['checkBox'] == true)
                                      todoList[i].setStatus('completed');
                                  }
                                  BlocProvider.of<TodoListBloc>(context)
                                      .state
                                      .list = todoList;
                                  BlocProvider.of<TodoListBloc>(context)
                                      .add(TodoListEvent.setMarkedAsCompleted);
                                  checkedMode = false;
                                } else {
                                  _showMyDialog();
                                }
                              },
                              child: (!checkedMode)
                                  ? Text('Add')
                                  : Text('Mark Completed'),
                            ),
                          ),
                          (checkedMode)
                              ? Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  width: 150,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.red),
                                    ),
                                    onPressed: () {
                                      for (var i = 0; i < len; i++) {
                                        if (isCheckedList[i]['checkBox'] ==
                                            true) {
                                          isCheckedList.removeAt(i);
                                          todoList.removeAt(i);
                                          i--;
                                        }
                                      }
                                      BlocProvider.of<TodoListBloc>(context)
                                          .state
                                          .list = todoList;
                                      BlocProvider.of<TodoListBloc>(context)
                                          .add(TodoListEvent.removeListActive);
                                      checkedMode = false;
                                      setState(() {});
                                    },
                                    child: Text('Remove'),
                                  ),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New List'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter todo list'),
                  controller: addList,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                todoList.add(new Todo(message: addList.text, status: 'active'));
                Map<String, dynamic> temp = {
                  'checkBox': false,
                  'edit': false,
                  'text': addList,
                  'prevText': addList.text
                };
                isCheckedList.add(temp);
                BlocProvider.of<TodoListBloc>(context).state.list = todoList;
                BlocProvider.of<TodoListBloc>(context)
                    .add(TodoListEvent.setListActive);
                addList.text = '';
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
