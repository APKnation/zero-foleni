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

  // Ticket management mutations
  static Future<Map<String, dynamic>> cancelTicket({required String number}) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': 'mutation { cancelTicket(number: "$number") { success message } }'}),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> rescheduleAppointment({
    required String number,
    required String newDate,
    required String newTime,
  }) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': 'mutation { rescheduleAppointment(number: "$number", newDate: "$newDate", newTime: "$newTime") { success message } }'}),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  // Bank operations
  static Future<Map<String, dynamic>> createBankTicket({
    required String bankId,
    required String branchId,
    required String serviceId,
    String tellerId = "",
  }) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': '''mutation { createBankTicket(bankId: "$bankId", branchId: "$branchId", serviceId: "$serviceId", tellerId: "$tellerId") { ticket { id number position status } success message } }'''
      }),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  static Map<String, dynamic> latestBankTicket = {};

  static Future<Map<String, dynamic>> bookBankAppointment({
    required String bankId,
    required String branchId,
    required String serviceId,
    required String date,
    required String time,
  }) async {
    final r = await http.post(
      Uri.parse(base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'query': '''mutation { bookBankAppointment(bankId: "$bankId", branchId: "$branchId", serviceId: "$serviceId", date: "$date", time: "$time") { appointment { id bank branch service date time status } success message } }'''
      }),
    );
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  // Data fetching methods
  static Future<List<Map>> getBranches({String? bankId}) async {
    final data = await query(bankId != null ? '{ branches(bankId: $bankId) { id name location } }' : '{ allBranches { id name location } }');
    final list = (data['data']?['allBranches'] ?? data['data']?['branches'] as List?) ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  static Future<List<Map>> getTellers({required String branchId}) async {
    final data = await query('{ tellers(branchId: "$branchId") { id name available } }');
    final list = (data['data']?['tellers'] as List?) ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  static Future<List<Map>> getBankServices({required String branchId}) async {
    final data = await query('{ bankServices(branchId: "$branchId") { id name } }');
    final list = (data['data']?['bankServices'] as List?) ?? [];
    return list.cast<Map<String, dynamic>>();
  }
}