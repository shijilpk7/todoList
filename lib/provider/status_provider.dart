import 'package:flutter/cupertino.dart';
import 'package:todo_list/data/repository/status_repository.dart';

class StatusProvider extends ChangeNotifier {
  String status = 'offline';
  final statusRepository = new StatusRepository();
  getStatus() async {
    try {
      this.status = await statusRepository.getStatus();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
