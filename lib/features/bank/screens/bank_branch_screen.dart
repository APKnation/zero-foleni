import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankBranchScreen extends StatelessWidget {
  final String bankId;
  const BankBranchScreen({super.key, required this.bankId});
  static const branches = ['Branch: City Centre', 'Branch: Ubungo', 'Branch: Kariakoo', 'Branch: Mikocheni'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Branch')),
      body: ListView.builder(
        itemCount: branches.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.location_city),
          title: Text(branches[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/bank-services/$bankId/b$i'),
        ),
      ),
    );
  }
}
