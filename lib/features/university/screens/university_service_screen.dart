import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class UniversityServiceScreen extends StatelessWidget {
  final String uniId;
  const UniversityServiceScreen({super.key, required this.uniId});
  static const services = ['Admissions and Registration','Academic Records and Examinations','Finance and Payments','Student Affairs','ICT Support','Library Services','Accommodation and Hostel Services','Clearance and Graduation'];

  static const _icons = <IconData>[
    Icons.app_registration,
    Icons.assignment,
    Icons.payments,
    Icons.people,
    Icons.computer,
    Icons.library_books,
    Icons.home,
    Icons.verified,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/universities')),
        title: const Text('University Services'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: services.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Icon(_icons[i % _icons.length], color: AppTheme.background),
            ),
            title: Text(services[i]),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: () => context.go('/uni-providers/$uniId/s$i'),
          ),
        ),
      ),
    );
  }
}
