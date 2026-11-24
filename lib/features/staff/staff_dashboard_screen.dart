import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/request_store.dart';
import '../../core/theme/app_theme.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RequestStore.instance;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Staff Dashboard'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final pending = store.requests.where((r) => r.status == RequestStatus.submitted || r.status == RequestStatus.waiting).toList();
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Card(margin: EdgeInsets.symmetric(vertical: 6), child: ListTile(title: Text('Next: Ticket #3321'), trailing: Icon(Icons.play_arrow, color: AppTheme.primary))),
              const Card(margin: EdgeInsets.symmetric(vertical: 6), child: ListTile(title: Text('Queue length: 8'))),
              const Card(margin: EdgeInsets.symmetric(vertical: 6), child: ListTile(title: Text('Status: Serving'))),
              const SizedBox(height: 12),
              const Text('Pending Service Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              if (pending.isEmpty)
                const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No pending requests'))),
              ...pending.map((r) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${r.serviceName} (${r.module})', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Provider: ${r.providerName}'),
                          Text('Applicant: ${r.userName}'),
                          if (r.details.isNotEmpty) Text('Details: ${r.details}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              FilledButton(
                                onPressed: () => store.approve(r.id),
                                child: const Text('Approve'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () => store.reject(r.id),
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
