import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QueueTrackingScreen extends StatelessWidget {
  const QueueTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () { if (Navigator.canPop(context)) { Navigator.pop(context); } else { context.go("/home"); } }), title: const Text('Queue Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: const [
          Text('Position: 4', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Patients ahead: 3'),
          Text('Estimated wait: 25 min'),
        ]),
      ),
    );
  }
}
