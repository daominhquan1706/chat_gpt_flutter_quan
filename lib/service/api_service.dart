import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> getData(String url) async {
    return http.get(Uri.parse(url));
  }

  static Future<http.Response> postData(String url, dynamic body) {
    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

  static Future<http.Response> putData(String url, dynamic body) {
    return http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

  static Future<http.Response> deleteData(String url) async {
    return http.delete(Uri.parse(url));
  }
}
