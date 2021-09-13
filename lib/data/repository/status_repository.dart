import 'package:flutter/cupertino.dart';
import 'package:todo_list/data/apiServices/status_api_service.dart';

class StatusRepository {
  final StatusApiService _statusApiService;

  StatusRepository({StatusApiService? statusApiService})
      : _statusApiService = statusApiService ?? StatusApiService();

  Future<String> getStatus() async {
    try {
      final data = await _statusApiService.getStatus();
      return data.toString();
    } catch (e) {
      debugPrint(e.toString());
      return 'offline';
    }
  }
}
