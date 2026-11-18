import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GovernmentListScreen extends StatelessWidget {
  const GovernmentListScreen({super.key});
  static const inst = ['NIDA – National Identification', 'BRELA – Business Registration', 'TRA – Taxpayer Services', 'RITA – Registration', 'Immigration Office', 'Local Government Office'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Government Offices')),
      body: ListView.builder(
        itemCount: inst.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.account_balance),
          title: Text(inst[i]),
          subtitle: const Text('Tanzania'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/gov-services/g$i'),
        ),
      ),
    );
  }
}
