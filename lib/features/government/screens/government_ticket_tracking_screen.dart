import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GovernmentTicketScreen extends StatelessWidget {
  const GovernmentTicketScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const BackButton(), title: const Text('Queue Ticket')),
    body: Center(child: Card(margin: const EdgeInsets.all(24), child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Ticket #5512', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('NIDA – National Identification'),
      const Text('NIDA ID Application'),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => context.go('/gov-tracking'), child: const Text('Track Queue')),
    ])))),
  );
}

class GovernmentTrackingScreen extends StatelessWidget {
  const GovernmentTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const BackButton(), title: const Text('Queue Tracking')),
    body: const Padding(padding: EdgeInsets.all(24), child: Column(children: [
      Text('Position: 6', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('People ahead: 5'),
      Text('Estimated wait: 40 min'),
    ])),
  );
}
