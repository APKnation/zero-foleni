import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class ServiceProvidersScreen extends StatelessWidget {
  final String? govId;
  final String? serviceId;
  const ServiceProvidersScreen({super.key, this.govId, this.serviceId});

  static const providers = ['Amina Juma', 'John Mwamba', 'Fatma Hassan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go(govId != null ? '/gov-services/$govId' : '/government')),
        title: const Text('Select Service Provider'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: providers.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.person, color: AppTheme.background),
            ),
            title: Text(providers[i]),
            subtitle: const Text('Available'),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: () => context.go('/gov-request/${govId ?? 'g0'}/${serviceId ?? 's0'}/${i + 1}'),
          ),
        ),
      ),
    );
  }
}
