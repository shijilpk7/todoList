import 'package:http/http.dart' as http;

class StatusProvider {
  Future<String> getStatus() async {
    try {
      final data = await http.get(Uri.parse(
          // 'http://t.i70clouds.com:5000/ping',
          'https://rest.ensembl.org/info/ping?'));
      if (data.statusCode == 200) return 'Online';
      return 'offline';
    } catch (e) {
      return 'offline';
    }
  }
}
