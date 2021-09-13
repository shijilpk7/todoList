import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/status_provider.dart';
import 'package:todo_list/provider/todo_list_provider.dart';
import 'package:todo_list/screens/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StatusProvider>(
            create: (context) => StatusProvider()),
        ChangeNotifierProvider<TodoListProvider>(
            create: (context) => TodoListProvider())
      ],
      child: MaterialApp(
        title: 'TODO List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'PoppinsMedium',
        ),
        home: Home(),
      ),
    );
  }
}
