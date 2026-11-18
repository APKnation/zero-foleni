import 'package:flutter/material.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: const BackButton(), title: const Text('Staff Dashboard')),
    body: ListView(children: const [
      ListTile(title: Text('Next: Ticket #1084'), trailing: Icon(Icons.play_arrow)),
      ListTile(title: Text('Queue length: 5')),
      ListTile(title: Text('Service status: Open')),
    ]),
  );
}
