import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankTicketScreen extends StatelessWidget {
  const BankTicketScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Queue Ticket')),
    body: Center(child: Card(margin: const EdgeInsets.all(24), child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Ticket #3321', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('NMB Bank'),
      const Text('Cash Deposit'),
      const Text('Teller: A. Juma'),
      const Text('Time: 10:30 AM'),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => context.go('/bank-tracking'), child: const Text('Track Queue')),
    ])))),
  );
}

class BankTrackingScreen extends StatelessWidget {
  const BankTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Queue Tracking')),
    body: const Padding(padding: EdgeInsets.all(24), child: Column(children: [
      Text('Position: 3', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('Customers ahead: 2'),
      Text('Estimated wait: 15 min'),
    ])),
  );
}
