import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/hospitals/hospital_list_screen.dart';
import '../../features/services/service_list_screen.dart';
import '../../features/university/screens/university_list_screen.dart';
import '../../features/university/screens/university_service_screen.dart';
import '../../features/university/screens/university_ticket_tracking_screen.dart';
import '../../features/staff/staff_dashboard_screen.dart';
import '../../features/government/screens/government_list_screen.dart';
import '../../features/government/screens/government_service_screen.dart';
import '../../features/government/screens/government_ticket_tracking_screen.dart';
import '../../features/government/screens/service_providers_screen.dart';
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
      GoRoute(path: '/universities', builder: (_, __) => const UniversityListScreen()),
      GoRoute(path: '/uni-services/:uniId', builder: (_, s) => UniversityServiceScreen(uniId: s.pathParameters['uniId']!)),
      GoRoute(path: '/uni-ticket', builder: (_, __) => const UniversityTicketScreen()),
      GoRoute(path: '/uni-tracking', builder: (_, __) => const UniversityTrackingScreen()),
      GoRoute(path: '/staff', builder: (_, __) => const StaffDashboardScreen()),
      GoRoute(path: '/government', builder: (_, __) => const GovernmentListScreen()),
      GoRoute(path: '/gov-services/:govId', builder: (_, s) => GovernmentServiceScreen(govId: s.pathParameters['govId']!)),
      GoRoute(path: '/gov-providers', builder: (_, __) => const ServiceProvidersScreen()),
      GoRoute(path: '/gov-ticket', builder: (_, __) => const GovernmentTicketScreen()),
      GoRoute(path: '/gov-tracking', builder: (_, __) => const GovernmentTrackingScreen()),
    ],
  );
});
