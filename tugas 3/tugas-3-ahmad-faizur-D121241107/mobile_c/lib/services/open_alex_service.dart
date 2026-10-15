import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/paper.dart';

class OpenAlexService {
  static Future<Paper> fetchRandomPaper() async {
    final apiKey = dotenv.env['OPENALEX_API_KEY'] ?? '';

    final queryParams = <String, String>{
      'filter': 'topics.field.id:17,has_fulltext:true',
      'sample': '1',
      'per_page': '1',
    };

    if (apiKey.isNotEmpty) {
      queryParams['api_key'] = apiKey;
    }

    final uri = Uri.https('api.openalex.org', '/works', queryParams);

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Server returned status code ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List results = data['results'] as List;

    if (results.isEmpty) {
      throw Exception('No papers found');
    }

    // Pass a single work object, not the whole response
    return Paper.fromJson(results.first as Map<String, dynamic>);
  }
}
