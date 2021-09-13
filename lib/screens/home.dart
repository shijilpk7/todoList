import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/status_provider.dart';
import 'package:todo_list/provider/todo_list_provider.dart';
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
    Provider.of<TodoListProvider>(context, listen: false).getListActive();

    super.initState();
  }

  String screen = 'active';
  @override
  Widget build(BuildContext context) {
    this.status = context
        .select<StatusProvider, String>((value) => this.status = value.status);
    Timer.periodic(Duration(seconds: 2), (_) {
      Provider.of<StatusProvider>(context, listen: false).getStatus();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            (status.toUpperCase() == 'ONLINE') ? Colors.green : Colors.red,
        title: Container(
          margin: EdgeInsets.only(left: 5),
          child: Text(this.status),
        ),
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
              title: Text(
                'Active Tasks',
              ),
              onTap: () {
                this.screen = 'active';
                Provider.of<TodoListProvider>(context, listen: false)
                    .getListActive();
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
            ListTile(
              title: Text('Completed Tasks'),
              onTap: () {
                this.screen = 'completed';
                Provider.of<TodoListProvider>(context, listen: false)
                    .getListCompleted();
                Navigator.of(context).pop();
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
