import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const base = 'http://10.0.2.2:8000/graphql/';
  static Future<Map<String, dynamic>> query(String q) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': q}),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
  static Future<List<Map>> banks() async {
    final data = await query('{ allBanks { id name code } }');
    final list = (data['data']?['allBanks'] as List?) ?? [];
    return list.cast<Map<String, dynamic>>();
  }
}
