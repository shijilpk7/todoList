import 'package:http/http.dart' as http;

class StatusApiService {
  Future<String> getStatus() async {
    try {
      final data =
          await http.get(Uri.parse('https://t.i70clouds.com:5000/ping'));
      if (data.statusCode == 200) return 'Online';
      return 'offline';
    } catch (e) {
      return 'offline';
    }
  }
}
