import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/bloc/status_bloc_bloc.dart';
import 'package:todo_list/bloc/bloc/todo_list_bloc.dart';
import 'package:todo_list/screens/widgets/active.dart';
import 'package:todo_list/screens/widgets/completd.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String status = 'offline';

  @override
  void initState() {
    BlocProvider.of<TodoListBloc>(context).add(TodoListEvent.getListActive);
    super.initState();
  }

  String screen = 'active';
  @override
  Widget build(BuildContext context) {
    // statusBloc.add(StatusBlocEvent.status);

    BlocProvider.of<TodoListBloc>(context).stream.listen((event) {
      // print(event.action);
    });

    Timer.periodic(Duration(seconds: 3), (_) {
      BlocProvider.of<StatusBloc>(context).add(StatusBlocEvent.status);
    });
    BlocProvider.of<StatusBloc>(context).stream.listen((event) {
      //print('dsf');

      if (this.status != event.status) {
        this.status = event.status;
        setState(() {});
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            (status.toUpperCase() == 'ONLINE') ? Colors.green : Colors.red,
        title: BlocBuilder<StatusBloc, StatusBlocState>(
          builder: (context, state) {
            AppBar(
              backgroundColor: (status.toUpperCase() == 'ONLINE')
                  ? Colors.green
                  : Colors.red,
            );
            return Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(state.status),
            );
          },
        ),
        //leadingWidth: 30,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              iconSize: 30,
              icon: Icon(Icons.menu),
            );
          }),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text('Todo List'),
              ),
            ),
            ListTile(
              title: Text('Active Tasks'),
              onTap: () {
                screen = 'active';
                BlocProvider.of<TodoListBloc>(context)
                    .add(TodoListEvent.getListActive);
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text('Completed Tasks'),
              onTap: () {
                screen = 'completed';
                BlocProvider.of<TodoListBloc>(context)
                    .add(TodoListEvent.getListCompleted);
                Navigator.pop(context);
                setState(() {});
              },
            )
          ],
        ),
      ),
      body: (screen == 'active') ? ActiveScreen() : CompletedScreen(),
    );
  }
}
