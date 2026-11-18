import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/router/auth_provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: const ZeroFoleniApp(),
    ),
  );
}

class ZeroFoleniApp extends ConsumerWidget {
  const ZeroFoleniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    
    // Build GoRouter with auth state
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        // Auth-required routes (will be guarded via redirect)
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/hospitals', builder: (_, __) => const HospitalListScreen()),
        GoRoute(path: '/services/:hospitalId', builder: (_, s) => ServiceListScreen(hospitalId: s.pathParameters['hospitalId']!)),
        GoRoute(path: '/booking/:hospitalId/:serviceId', builder: (_, s) => BookingScreen(hospitalId: s.pathParameters['hospitalId']!, serviceId: s.pathParameters['serviceId']!)),
        GoRoute(path: '/ticket', builder: (_, __) => const QueueTicketScreen()),
        GoRoute(path: '/tracking', builder: (_, __) => const QueueTrackingScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
        
        // University routes
        GoRoute(path: '/universities', builder: (_, __) => const UniversityListScreen()),
        GoRoute(path: '/uni-services/:uniId', builder: (_, s) => UniversityServiceScreen(uniId: s.pathParameters['uniId']!)),
        GoRoute(path: '/uni-ticket', builder: (_, __) => const UniversityTicketScreen()),
        GoRoute(path: '/uni-tracking', builder: (_, __) => const UniversityTrackingScreen()),
        
        // Government routes
        GoRoute(path: '/government', builder: (_, __) => const GovernmentListScreen()),
        GoRoute(path: '/gov-services/:govId', builder: (_, s) => GovernmentServiceScreen(govId: s.pathParameters['govId']!)),
        GoRoute(path: '/gov-ticket', builder: (_, __) => const GovernmentTicketScreen()),
        GoRoute(path: '/gov-tracking', builder: (_, __) => const GovernmentTrackingScreen()),
        
        // Bank routes
        GoRoute(path: '/bank', builder: (_, __) => const BankListScreen()),
        GoRoute(path: '/bank-branches/:bankId', builder: (_, s) => BankBranchScreen(bankId: s.pathParameters['bankId']!)),
        GoRoute(path: '/bank-services/:bankId/:branchId', builder: (_, s) => BankServiceScreen(bankId: s.pathParameters['bankId']!, branchId: s.pathParameters['branchId']!)),
        GoRoute(path: '/bank-providers/:bankId/:branchId/:serviceId', builder: (_, s) => BankProviderScreen(bankId: s.pathParameters['bankId']!, branchId: s.pathParameters['branchId']!, serviceId: s.pathParameters['serviceId']!)),
        GoRoute(path: '/bank-booking/:bankId/:branchId/:serviceId/:providerId', builder: (_, s) => BankBookingScreen(bankId: s.pathParameters['bankId']!, branchId: s.pathParameters['branchId']!, serviceId: s.pathParameters['serviceId']!, providerId: s.pathParameters['providerId']!)),
        GoRoute(path: '/bank-ticket', builder: (_, __) => const BankTicketScreen()),
        GoRoute(path: '/bank-tracking', builder: (_, __) => const BankTrackingScreen()),
        GoRoute(path: '/bank-teller', builder: (_, __) => const BankTellerDashboardScreen()),
        GoRoute(path: '/bank-branch-manager', builder: (_, __) => const BankBranchManagerScreen()),
        GoRoute(path: '/bank-admin', builder: (_, __) => const BankAdminDashboardScreen()),
        
        // Auth routes (public)
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/register', builder: (_, __) => const CitizenRegisterScreen()),
        
        // Onboarding
        GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      ],
      // Auth guard: redirect based on login state
      redirect: (context, state) {
        final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register' || state.matchedLocation == '/onboarding';
        
        if (!auth.isLoggedIn && !isAuthRoute) {
          // Not logged in and trying to access protected route
          return '/login';
        }
        
        if (auth.isLoggedIn && isAuthRoute) {
          // Logged in and trying to access auth routes
          return '/home';
        }
        
        return null; // allow navigation
      },
    );

    return MaterialApp.router(
      title: 'ZeroFoleni',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}