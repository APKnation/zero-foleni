import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankServiceScreen extends StatelessWidget {
  final String bankId;
  final String branchId;
  const BankServiceScreen({super.key, required this.bankId, required this.branchId});
  static const services = ['Account Opening', 'Cash Deposit', 'Cash Withdrawal', 'Money Transfer', 'Loan Services', 'ATM Card Services', 'Customer Support'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Service')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.attach_money),
          title: Text(services[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/bank-providers/$bankId/$branchId/s$i'),
        ),
      ),
    );
  }
}
