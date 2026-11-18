import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String? _overrideBaseUrl;
  static Map<String, dynamic>? latestBankTicket;

  static String get base {
    if (_overrideBaseUrl != null && _overrideBaseUrl!.isNotEmpty) {
      return _overrideBaseUrl!;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/graphql/';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/graphql/';
    }
    return 'http://127.0.0.1:8000/graphql/';
  }

  static void setBaseUrl(String url) {
    _overrideBaseUrl = url;
  }

  static Future<Map<String, dynamic>> query(
    String q, {
    Map<String, dynamic>? variables,
  }) async {
    try {
      final r = await http.post(
        Uri.parse(base),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': q,
          ...?variables == null ? null : {'variables': variables},
        }),
      ).timeout(const Duration(seconds: 7));

      if (r.statusCode >= 200 && r.statusCode < 300) {
        return jsonDecode(r.body) as Map<String, dynamic>;
      } else {
        return {
          'errors': [
            {'message': 'HTTP ${r.statusCode}: ${r.body}'}
          ]
        };
      }
    } catch (e) {
      return {
        'errors': [
          {'message': e.toString()}
        ]
      };
    }
  }

  /// Health check query: verifies backend connectivity
  static Future<bool> checkConnection() async {
    try {
      final res = await query('{ hello }');
      return res['data']?['hello'] != null;
    } catch (_) {
      return false;
    }
  }

  // --- Banks ---

  static Future<List<Map<String, dynamic>>> banks() async {
    try {
      final data = await query('{ allBanks { id name code } }');
      final list = (data['data']?['allBanks'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getBranches(String bankId) async {
    try {
      final data = await query('''
        query {
          branches(bankId: "$bankId") {
            id
            name
            location
          }
        }
      ''');
      final list = (data['data']?['branches'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getBankServices(String branchId) async {
    try {
      final data = await query('''
        query {
          bankServices(branchId: "$branchId") {
            id
            name
          }
        }
      ''');
      final list = (data['data']?['bankServices'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getTellers(String branchId) async {
    try {
      final data = await query('''
        query {
          tellers(branchId: "$branchId") {
            id
            name
            available
          }
        }
      ''');
      final list = (data['data']?['tellers'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> createBankTicket({
    required String bankId,
    required String branchId,
    required String serviceId,
    String? tellerId,
  }) async {
    final tellerArg = tellerId != null && tellerId.isNotEmpty ? ', tellerId: "$tellerId"' : '';
    final res = await query('''
      mutation {
        createBankTicket(bankId: "$bankId", branchId: "$branchId", serviceId: "$serviceId"$tellerArg) {
          success
          message
          ticket {
            id
            number
            position
            status
          }
        }
      }
    ''');
    return res['data']?['createBankTicket'] ?? {
      'success': false,
      'message': res['errors']?[0]?['message'] ?? 'Connection error',
    };
  }

  static Future<Map<String, dynamic>> bookBankAppointment({
    required String bankId,
    required String branchId,
    required String serviceId,
    required String date,
    required String time,
  }) async {
    final res = await query('''
      mutation {
        bookBankAppointment(bankId: "$bankId", branchId: "$branchId", serviceId: "$serviceId", date: "$date", time: "$time") {
          success
          message
          appointment {
            id
            date
            time
            status
          }
        }
      }
    ''');
    return res['data']?['bookBankAppointment'] ?? {
      'success': false,
      'message': res['errors']?[0]?['message'] ?? 'Connection error',
    };
  }

  static Future<Map<String, dynamic>?> getBankTicket(String number) async {
    try {
      final res = await query('''
        query {
          bankTicket(number: "$number") {
            id
            number
            position
            status
            bank { name }
            branch { name }
            service { name }
            teller { name }
            createdAt
          }
        }
      ''');
      return res['data']?['bankTicket'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  // --- Institutions (Hospitals, Universities, Government) ---

  static Future<List<Map<String, dynamic>>> getInstitutions({String? type}) async {
    try {
      final typeArg = type != null ? '(type: "$type")' : '';
      final res = await query('''
        query {
          allInstitutions$typeArg {
            id
            name
            type
            location
          }
        }
      ''');
      final list = (res['data']?['allInstitutions'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getServices(String institutionId) async {
    try {
      final res = await query('''
        query {
          services(institutionId: "$institutionId") {
            id
            name
          }
        }
      ''');
      final list = (res['data']?['services'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getServiceProviders(String serviceId) async {
    try {
      final res = await query('''
        query {
          serviceProviders(serviceId: "$serviceId") {
            id
            name
            available
          }
        }
      ''');
      final list = (res['data']?['serviceProviders'] as List?) ?? [];
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // --- Citizen Auth ---

  static Future<Map<String, dynamic>> registerCitizen({
    required String fullName,
    required String phone,
    required String password,
    String email = '',
    String nationalId = '',
  }) async {
    final res = await query('''
      mutation {
        registerCitizen(
          fullName: "$fullName",
          phone: "$phone",
          password: "$password",
          email: "$email",
          nationalId: "$nationalId"
        ) {
          success
          message
          citizen {
            id
            fullName
            phone
            email
            nationalId
          }
        }
      }
    ''');
    return res['data']?['registerCitizen'] ?? {
      'success': false,
      'message': res['errors']?[0]?['message'] ?? 'Connection failed',
    };
  }

  static Future<Map<String, dynamic>> loginCitizen({
    required String phone,
    required String password,
  }) async {
    final res = await query('''
      mutation {
        loginCitizen(phone: "$phone", password: "$password") {
          success
          message
          token
          citizen {
            id
            fullName
            phone
            email
            nationalId
          }
        }
      }
    ''');
    return res['data']?['loginCitizen'] ?? {
      'success': false,
      'message': res['errors']?[0]?['message'] ?? 'Connection failed',
    };
  }
}
