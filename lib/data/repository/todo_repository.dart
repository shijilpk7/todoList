import 'package:shared_preferences/shared_preferences.dart';

class TodoRepository {
  late SharedPreferences prefs;

  Future<String> getList() async {
    try {
      this.prefs = await SharedPreferences.getInstance();
      String? data = this.prefs.getString('todoList');
      return data ?? '';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> setList(String data) async {
    try {
      this.prefs = await SharedPreferences.getInstance();
      this.prefs.setString('todoList', data);
      return data;
    } on Exception catch (_) {
      return 'failed';
    }
  }
}
