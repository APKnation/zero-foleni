import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Auth state stored in shared preferences
class AuthState {
  final bool isLoggedIn;
  final String? phone;
  final String? token;
  final String? fullName;

  AuthState._internal({
    required this.isLoggedIn,
    required this.phone,
    required this.token,
    required this.fullName,
  });

  static const _key = 'auth_state';

  factory AuthState.fromSharedPrefs(SharedPreferences prefs) {
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final phone = prefs.getString('phone');
    final token = prefs.getString('token');
    final fullName = prefs.getString('fullName');
    return AuthState._internal(
      isLoggedIn: isLoggedIn,
      phone: phone,
      token: token,
      fullName: fullName,
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoggedIn': isLoggedIn,
    'phone': phone,
    'token': token,
    'fullName': fullName,
  };

  void saveToSharedPrefs(SharedPreferences prefs) {
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('phone', phone);
    prefs.setString('token', token);
    prefs.setString('fullName', fullName);
  }
}

/// Riverpod provider for shared preferences
final sharedPrefsProvider = FutureProvider((ref) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  return sharedPrefs;
});

/// Riverpod provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final sharedPrefs = ref.watch(sharedPrefsProvider);
  return AuthNotifier(
    initialState: AuthState.fromSharedPrefs(sharedPrefs!),
    ref: ref,
    prefs: sharedPrefs,
  );
});

/// Auth notifier that handles login/logout state
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  final SharedPreferences _prefs;

  AuthNotifier({
    required AuthState initialState,
    required Ref ref,
    required SharedPreferences prefs,
  }) : _ref = ref,
       _prefs = prefs,
       super(initialState) {
    // Listen for changes and persist
    // Use didChangeDependencies pattern or manual persist on change
}

  Future<void> login(String phone, String password) async {
    // TODO: Call GraphQL login mutation
    // For now, set local auth state
    state = AuthState._internal(
      isLoggedIn: true,
      phone: phone,
      token: 'temp-token-${phone.hashCode}',
      fullName: 'Citizen',
    );
  }

  Future<void> logout() async {
    state = AuthState._internal(
      isLoggedIn: false,
      phone: null,
      token: null,
      fullName: null,
    );
  }
}