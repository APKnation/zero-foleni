import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceListScreen extends StatelessWidget {
  final String hospitalId;
  const ServiceListScreen({super.key, required this.hospitalId});
  static const services = ['Dental', 'General Consultation', 'Laboratory', 'Pharmacy', 'Maternity'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.medical_services),
          title: Text(services[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/booking/$hospitalId/s$i'),
        ),
      ),
    );
  }
}
