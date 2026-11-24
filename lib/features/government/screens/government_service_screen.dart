import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class GovernmentServiceScreen extends StatelessWidget {
  final String govId;
  const GovernmentServiceScreen({super.key, required this.govId});
  static const services = ['NIDA ID Application', 'Business Registration', 'Tax Filing', 'Birth Registration', 'Passport Application', 'Land Title Transfer'];

  static const _icons = <IconData>[
    Icons.badge,
    Icons.business,
    Icons.receipt,
    Icons.child_care,
    Icons.flight,
    Icons.landscape,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/government')),
        title: const Text('Government Services'),
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
            onTap: () => context.go('/gov-providers/$govId/s$i'),
          ),
        ),
      ),
    );
  }
}
