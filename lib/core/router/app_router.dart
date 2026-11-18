import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/hospitals/hospital_list_screen.dart';
import '../../features/services/service_list_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/queue/queue_ticket_screen.dart';
import '../../features/queue/queue_tracking_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/history/history_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/hospitals', builder: (_, __) => const HospitalListScreen()),
      GoRoute(path: '/services/:hospitalId', builder: (_, s) => ServiceListScreen(hospitalId: s.pathParameters['hospitalId']!)),
      GoRoute(path: '/booking/:hospitalId/:serviceId', builder: (_, s) => BookingScreen(hospitalId: s.pathParameters['hospitalId']!, serviceId: s.pathParameters['serviceId']!)),
      GoRoute(path: '/ticket', builder: (_, __) => const QueueTicketScreen()),
      GoRoute(path: '/tracking', builder: (_, __) => const QueueTrackingScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
    ],
  );
});
