import 'package:todo_list/data/provider/status_provider.dart';

class StatusRepository {
  final StatusProvider _statusProvider;

  StatusRepository({StatusProvider? statusProvider})
      : _statusProvider = statusProvider ?? StatusProvider();

  Future<String> getStatus() async {
    final data = await _statusProvider.getStatus();
    return data.toString();
  }
}
