import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceProvidersScreen extends StatelessWidget {
  const ServiceProvidersScreen({super.key});
  static const providers = ['Amina Juma', 'John Mwamba', 'Fatma Hassan'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Service Provider')),
      body: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.person),
          title: Text(providers[i]),
          subtitle: const Text('Available'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/gov-ticket'),
        ),
      ),
    );
  }
}
