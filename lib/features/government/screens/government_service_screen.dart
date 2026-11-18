import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GovernmentServiceScreen extends StatelessWidget {
  final String govId;
  const GovernmentServiceScreen({super.key, required this.govId});
  static const services = ['NIDA ID Application', 'Business Registration', 'Tax Filing', 'Birth Registration', 'Passport Application', 'Land Title Transfer'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () { if (Navigator.canPop(context)) { Navigator.pop(context); } else { context.go("/home"); } }), title: const Text('Government Services')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.description),
          title: Text(services[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/gov-ticket'),
        ),
      ),
    );
  }
}
