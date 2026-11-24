import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Staff Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Card(margin: EdgeInsets.symmetric(vertical: 6), child: ListTile(title: Text('Next: Ticket #3321'), trailing: Icon(Icons.play_arrow, color: AppTheme.primary))),
          Card(margin: EdgeInsets.symmetric(vertical: 6), child: ListTile(title: Text('Queue length: 8'))),
          Card(margin: EdgeInsets.symmetric(vertical: 6), child: ListTile(title: Text('Status: Serving'))),
        ],
      ),
    );
  }
}
