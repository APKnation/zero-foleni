import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: () { if (Navigator.canPop(context)) { Navigator.pop(context); } else { context.go("/home"); } }), title: const Text('Staff Dashboard')),
    body: ListView(children: const [
      ListTile(title: Text('Next: Ticket #1084'), trailing: Icon(Icons.play_arrow)),
      ListTile(title: Text('Queue length: 5')),
      ListTile(title: Text('Service status: Open')),
    ]),
  );
}
