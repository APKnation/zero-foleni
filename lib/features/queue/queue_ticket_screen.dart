import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QueueTicketScreen extends StatelessWidget {
  const QueueTicketScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue Ticket')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Ticket #Z-042', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Muhimbili National Hospital'),
              const Text('General Consultation'),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => context.go('/tracking'), child: const Text('Track Queue')),
            ]),
          ),
        ),
      ),
    );
  }
}
