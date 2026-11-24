import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class UniversityProviderScreen extends StatelessWidget {
  final String uniId;
  final String serviceId;
  const UniversityProviderScreen({super.key, required this.uniId, required this.serviceId});

  static const _providers = [
    {'id': '1', 'name': 'Desk Officer: A. Juma', 'status': 'Available'},
    {'id': '2', 'name': 'Desk Officer: J. Mwamba', 'status': 'Available'},
    {'id': '3', 'name': 'Desk Officer: F. Hassan', 'status': 'Busy'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/uni-services/$uniId')),
        title: const Text('Select Service Desk'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _providers.length,
        itemBuilder: (_, i) {
          final p = _providers[i];
          final available = p['status'] == 'Available';
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: available ? AppTheme.primary : AppTheme.accent,
                child: Icon(Icons.person, color: AppTheme.background),
              ),
              title: Text(p['name'] ?? ''),
              subtitle: Text(p['status'] ?? ''),
              trailing: Icon(Icons.chevron_right, color: available ? AppTheme.primary : Colors.grey),
              onTap: available ? () => context.go('/uni-request/$uniId/$serviceId/${p['id']}') : null,
            ),
          );
        },
      ),
    );
  }
}
