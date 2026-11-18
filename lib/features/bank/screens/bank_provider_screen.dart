import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankProviderScreen extends StatelessWidget {
  final String bankId;
  final String branchId;
  final String serviceId;
  const BankProviderScreen({super.key, required this.bankId, required this.branchId, required this.serviceId});
  static const providers = ['Teller: A. Juma', 'Teller: J. Mwamba', 'Teller: F. Hassan'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Teller')),
      body: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.person),
          title: Text(providers[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/bank-booking/$bankId/$branchId/$serviceId/p$i'),
        ),
      ),
    );
  }
}
