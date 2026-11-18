import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankTellerDashboardScreen extends StatelessWidget {
  const BankTellerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Teller Dashboard')),
    body: ListView(children: const [
      ListTile(title: Text('Next: Ticket #3321'), trailing: Icon(Icons.play_arrow)),
      ListTile(title: Text('Queue length: 8')),
      ListTile(title: Text('Status: Serving')),
    ]),
  );
}

class BankBranchManagerScreen extends StatelessWidget {
  const BankBranchManagerScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Branch Manager')),
    body: ListView(children: const [
      ListTile(title: Text('Today tickets: 120')),
      ListTile(title: Text('Completed: 95')),
      ListTile(title: Text('Waiting: 10')),
    ]),
  );
}

class BankAdminDashboardScreen extends StatelessWidget {
  const BankAdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bank Admin')),
    body: ListView(children: const [
      ListTile(title: Text('Branches: 12')),
      ListTile(title: Text('Active tellers: 48')),
      ListTile(title: Text('Reports: View')),
    ]),
  );
}
