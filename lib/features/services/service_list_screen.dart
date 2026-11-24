import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class ServiceListScreen extends StatelessWidget {
  final String hospitalId;
  const ServiceListScreen({super.key, required this.hospitalId});
  static const services = ['Dental', 'General Consultation', 'Laboratory', 'Pharmacy', 'Maternity'];

  static const _icons = <IconData>[
    Icons.medical_services,
    Icons.local_hospital,
    Icons.science,
    Icons.local_pharmacy,
    Icons.pregnant_woman,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/hospitals')),
        title: const Text('Departments'),
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
            onTap: () => context.go('/booking/$hospitalId/s$i'),
          ),
        ),
      ),
    );
  }
}
