import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

/// Riverpod provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Initialize from shared prefs on app start
  final prefs = ref.read(sharedPrefsProvider);
  return AuthNotifier(
    initialState: AuthState.fromSharedPrefs(prefs),
    ref: ref,
    prefs: prefs,
  );
});

/// Shared preferences provider
final sharedPrefsProvider = Provider((ref) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  return sharedPrefs;
});

/// Auth notifier that handles login/logout state
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final SharedPreferences prefs;

  AuthNotifier({
    required AuthState initialState,
    required this.ref,
    required this.prefs,
  }) : super(initialState) {
    // Listen for changes and persist
    ever(state, (_) => state.saveToSharedPrefs(prefs));
  }

  Future<void> login(String phone, String password) async {
    // TODO: Call GraphQL login_citizen mutation
    // For now, set local auth state
    state = AuthState._internal(
      isLoggedIn: true,
      phone: phone,
      token: 'temp-token-${phone.hashCode}',
      fullName: 'Citizen', // would come from backend
    );
  }

  void logout() {
    state = AuthState._internal(
      isLoggedIn: false,
      phone: null,
      token: null,
      fullName: null,
    );
  }
}

/// GoRouter guard for authenticated routes
class AuthGuard extends GoRouteRedirect {
  AuthGuard({required WidgetRef ref}) : super(
    path: '/',
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      if (auth.isLoggedIn) return null; // allow access
      return '/login'; // redirect to login
    },
  );

  // Also guard unauthenticated routes
  static GoRouteRedirect unauthenticatedGuard(WidgetRef ref) => GoRouteRedirect(
    path: '/login',
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      if (!auth.isLoggedIn) return null; // allow access to login/register
      return '/home'; // redirect authenticated users away
    },
  );
}