import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('List models', () async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GROQ_API_KEY'];
    final response = await http.get(
      Uri.parse('https://api.groq.com/openai/v1/models'),
      headers: {'Authorization': 'Bearer $apiKey'},
    );
    print(response.body);
  });
}
