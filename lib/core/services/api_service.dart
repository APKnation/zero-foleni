import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use environment variable for API base URL
  static const String _envBase = String.fromEnvironment('GRAPHQL_BASE_URL', defaultValue: 'http://10.0.2.2:8000/graphql/');
  
  static const base = _envBase;

  static Future<Map<String, dynamic>> query(String q) async {
    try {
      final r = await http.post(
        Uri.parse(base),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': q}),
      );
      return jsonDecode(r.body) as Map<String, dynamic>;
    } catch (e) {
      // Re-throw with context
      rethrow;
    }
  }

  static Future<List<Map>> banks() async {
    final data = await query('{ allBanks { id name code } }');
    final list = (data['data']?['allBanks'] as List?) ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  static Future<Map<String, dynamic>> registerCitizen({
    required String fullName,
    required String phone,
    required String password,
    String email = '',
    String nationalId = '',
  }) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': '''mutation { registerCitizen(fullName: "$fullName", phone: "$phone", password: "$password", email: "$email", nationalId: "$nationalId") { citizen { id fullName phone email nationalId } success message } }'''
      }),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> loginCitizen({
    required String phone,
    required String password,
  }) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': '''mutation { loginCitizen(phone: "$phone", password: "$password") { citizen { id fullName phone email nationalId } success message token } }'''
      }),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }
}