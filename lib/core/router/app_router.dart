import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/citizen_register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/hospitals/hospital_list_screen.dart';
import '../../features/services/service_list_screen.dart';
import '../../features/pharmacy/pharmacy_list_screen.dart';
import '../../features/university/screens/university_list_screen.dart';
import '../../features/university/screens/university_service_screen.dart';
import '../../features/university/screens/university_provider_screen.dart';
import '../../features/university/screens/university_request_screen.dart';
import '../../features/university/screens/university_provider_screen.dart';
import '../../features/university/screens/university_ticket_tracking_screen.dart';
import '../../features/staff/staff_dashboard_screen.dart';
import '../../features/government/screens/government_list_screen.dart';
import '../../features/government/screens/government_service_screen.dart';
import '../../features/government/screens/government_ticket_tracking_screen.dart';
import '../../features/government/screens/service_providers_screen.dart';
import '../../features/government/screens/government_request_screen.dart';
import '../../features/bank/screens/bank_list_screen.dart';
import '../../features/bank/screens/bank_branch_screen.dart';
import '../../features/bank/screens/bank_service_screen.dart';
import '../../features/bank/screens/bank_provider_screen.dart';
import '../../features/bank/screens/bank_booking_screen.dart';
import '../../features/bank/screens/bank_ticket_tracking_screen.dart';
import '../../features/bank/screens/bank_staff_screens.dart';
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
      GoRoute(path: '/register', builder: (_, __) => const CitizenRegisterScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/hospitals', builder: (_, __) => const HospitalListScreen()),
      GoRoute(path: '/services/:hospitalId', builder: (_, s) => ServiceListScreen(hospitalId: s.pathParameters['hospitalId']!)),
      GoRoute(path: '/pharmacies', builder: (_, __) => const PharmacyListScreen()),
      GoRoute(path: '/booking/:hospitalId/:serviceId', builder: (_, s) => BookingScreen(hospitalId: s.pathParameters['hospitalId']!, serviceId: s.pathParameters['serviceId']!)),
      GoRoute(path: '/ticket', builder: (_, __) => const QueueTicketScreen()),
      GoRoute(path: '/tracking', builder: (_, __) => const QueueTrackingScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
      GoRoute(path: '/universities', builder: (_, __) => const UniversityListScreen()),
      GoRoute(path: '/uni-services/:uniId', builder: (_, s) => UniversityServiceScreen(uniId: s.pathParameters['uniId']!)),
      GoRoute(path: '/uni-providers/:uniId/:serviceId', builder: (_, s) => UniversityProviderScreen(uniId: s.pathParameters['uniId']!, serviceId: s.pathParameters['serviceId']!)),
      GoRoute(path: '/uni-request/:uniId/:serviceId/:providerId', builder: (_, s) => UniversityRequestScreen(uniId: s.pathParameters['uniId']!, serviceId: s.pathParameters['serviceId']!, providerId: s.pathParameters['providerId']!)),
      GoRoute(path: '/uni-providers/:uniId/:serviceId', builder: (_, s) => UniversityProviderScreen(uniId: s.pathParameters['uniId']!, serviceId: s.pathParameters['serviceId']!)),
      GoRoute(path: '/uni-ticket', builder: (_, __) => const UniversityTicketScreen()),
      GoRoute(path: '/uni-tracking', builder: (_, __) => const UniversityTrackingScreen()),
      GoRoute(path: '/staff', builder: (_, __) => const StaffDashboardScreen()),
      GoRoute(path: '/government', builder: (_, __) => const GovernmentListScreen()),
      GoRoute(path: '/gov-services/:govId', builder: (_, s) => GovernmentServiceScreen(govId: s.pathParameters['govId']!)),
      GoRoute(path: '/gov-providers', builder: (_, __) => const ServiceProvidersScreen()),
      GoRoute(path: '/gov-providers/:govId/:serviceId', builder: (_, s) => ServiceProvidersScreen(govId: s.pathParameters['govId'], serviceId: s.pathParameters['serviceId'])),
      GoRoute(path: '/gov-request/:govId/:serviceId/:providerId', builder: (_, s) => GovernmentRequestScreen(govId: s.pathParameters['govId']!, serviceId: s.pathParameters['serviceId']!, providerId: s.pathParameters['providerId']!)),
      GoRoute(path: '/gov-ticket', builder: (_, __) => const GovernmentTicketScreen()),
      GoRoute(path: '/gov-tracking', builder: (_, __) => const GovernmentTrackingScreen()),
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
      GoRoute(path: '/bank-reschedule', builder: (_, __) => const BankRescheduleScreen()),
    ],
  );
});
