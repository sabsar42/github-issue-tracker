import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchIssues() async {
  final response = await http.get(
    Uri.parse('https://api.github.com/repos/flutter/flutter/issues'),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load issues');
  }
}
