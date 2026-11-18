import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple auth state managed via shared preferences
class AuthService {
  static const _key = 'zerofoleni_auth';
  
  // Read auth state from shared prefs
  static AuthState? load(SharedPreferences prefs) {
    final json = prefs.getString(_key);
    if (json == null) return null;
    // Decode and return
    return AuthState(
      isLoggedIn: json.contains('isLoggedIn:true'),
      phone: json.contains('phone:"') ? json.substring(json.indexOf('phone:"') + 6, json.indexOf('"', json.indexOf('phone:"') + 7)) : null,
      token: json.contains('token:"') ? json.substring(json.indexOf('token:"') + 6, json.indexOf('"', json.indexOf('token:"') + 7)) : null,
      fullName: json.contains('fullName:"') ? json.substring(json.indexOf('fullName:"') + 10, json.indexOf('"', json.indexOf('fullName:"') + 11)) : null,
    );
  }

  // Save auth state to shared prefs
  static void save(SharedPreferences prefs, AuthState? state) {
    if (state == null) {
      prefs.remove(_key);
    } else {
      final json = '''
{
  "isLoggedIn": ${state.isLoggedIn},
  "phone": "${state.phone}",
  "token": "${state.token}",
  "fullName": "${state.fullName}"
}
      ''';
      prefs.setString(_key, json);
    }
  }
}

/// Auth state model
class AuthState {
  final bool isLoggedIn;
  final String? phone;
  final String? token;
  final String? fullName;

  AuthState({
    this.isLoggedIn = false,
    this.phone,
    this.token,
    this.fullName,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? phone,
    String? token,
    String? fullName,
  }) => AuthState(
    isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    phone: phone ?? this.phone,
    token: token ?? this.token,
    fullName: fullName ?? this.fullName,
  );
}

// Riverpod provider for shared preferences
final sharedPrefsProvider = FutureProvider((ref) async {
  final sp = await SharedPreferences.getInstance();
  return sp;
});

// Auth state provider - uses shared prefs
final authStateProvider = StateProvider<AuthState>((ref) {
  final sp = ref.watch(sharedPrefsProvider);
  // Return initial state - in a real app you'd load from sp
  return AuthState();
});

// Auth notifier - handles login/logout actions
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Login - sets auth state locally (would call GraphQL in production)
  void login(String phone, String password) {
    state = AuthState(
      isLoggedIn: true,
      phone: phone,
      token: 'mock-token',
      fullName: 'Citizen',
    );
  }

  // Logout - clears auth state
  void logout() {
    state = AuthState();
  }
}

// Final combined provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});