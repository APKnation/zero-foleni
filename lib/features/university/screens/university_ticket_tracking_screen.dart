import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UniversityTicketScreen extends StatelessWidget {
  const UniversityTicketScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: () { if (Navigator.canPop(context)) { Navigator.pop(context); } else { context.go("/home"); } }), title: const Text('Queue Ticket')),
    body: Center(child: Card(margin: const EdgeInsets.all(24), child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Ticket #1084', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('University of Dar es Salaam'),
      const Text('Finance and Payments'),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => context.go('/uni-tracking'), child: const Text('Track Queue')),
    ])))),
  );
}

class UniversityTrackingScreen extends StatelessWidget {
  const UniversityTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: () { if (Navigator.canPop(context)) { Navigator.pop(context); } else { context.go("/home"); } }), title: const Text('Queue Tracking')),
    body: const Padding(padding: EdgeInsets.all(24), child: Column(children: [
      Text('Position: 2', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('People ahead: 1'),
      Text('Estimated wait: 10 min'),
    ])),
  );
}
