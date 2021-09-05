import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/bloc/todo_list_bloc.dart';
import 'package:todo_list/data/models/todo.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
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
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width * .55,
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
              child: (checkedMode)
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                          .add(TodoListEvent
                                              .removeListCompleted);
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
