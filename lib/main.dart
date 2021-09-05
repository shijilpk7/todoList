import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/bloc/status_bloc_bloc.dart';
import 'package:todo_list/bloc/bloc/todo_list_bloc.dart';
import 'package:todo_list/screens/home.dart';

Future main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StatusBloc()),
        BlocProvider(create: (context) => TodoListBloc())
      ],
      child: MaterialApp(
        title: 'TODO List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}
