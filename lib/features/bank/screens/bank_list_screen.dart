import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankListScreen extends StatelessWidget {
  const BankListScreen({super.key});
  static const banks = ['NMB', 'CRDB', 'NBC', 'Stanbic Bank', 'Exim Bank', 'Azania Bank'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Bank')),
      body: ListView.builder(
        itemCount: banks.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.account_balance),
          title: Text(banks[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/bank-branches/b$i'),
        ),
      ),
    );
  }
}
