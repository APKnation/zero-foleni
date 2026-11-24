import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/request_store.dart';
import '../../core/theme/app_theme.dart';

class RequestStatusScreen extends StatelessWidget {
  final String requestId;
  const RequestStatusScreen({super.key, required this.requestId});

  String _trackingRoute(String module) {
    switch (module) {
      case 'university':
        return '/uni-tracking';
      case 'government':
        return '/gov-tracking';
      case 'bank':
        return '/bank-tracking';
      default:
        return '/tracking';
    }
  }

  Color _statusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.submitted:
        return AppTheme.primary;
      case RequestStatus.waiting:
        return Colors.orange;
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return AppTheme.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = RequestStore.instance;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Request Status'),
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final req = store.find(requestId);
          if (req == null) {
            return const Center(child: Text('Request not found'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(req.serviceName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Provider: ${req.providerName}'),
                        Text('Applicant: ${req.userName}'),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(req.statusLabel),
                          backgroundColor: _statusColor(req.status).withOpacity(0.15),
                          labelStyle: TextStyle(color: _statusColor(req.status), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _radioStep('Submitted', req.status.index >= RequestStatus.submitted.index, _statusColor(RequestStatus.submitted)),
                    _radioStep('Waiting', req.status.index >= RequestStatus.waiting.index, _statusColor(RequestStatus.waiting)),
                    _radioStep(req.status == RequestStatus.rejected ? 'Rejected' : 'Approved', req.status == RequestStatus.approved || req.status == RequestStatus.rejected, req.status == RequestStatus.rejected ? AppTheme.accent : Colors.green),
                  ],
                ),
                const SizedBox(height: 16),
                if (req.details.isNotEmpty) ...[
                  const Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(req.details),
                  const SizedBox(height: 16),
                ],
                if (req.status == RequestStatus.approved) ...[
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ticket: ${req.ticketNumber}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                          if (req.scheduledTime != null)
                            Text('Scheduled time: ${req.scheduledTime!.hour.toString().padLeft(2, '0')}:${req.scheduledTime!.minute.toString().padLeft(2, '0')}'),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => context.go(_trackingRoute(req.module)),
                            child: const Text('Track Queue'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (req.status == RequestStatus.rejected) ...[
                  const Card(
                    color: Color(0xFFFFEBEE),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Your request was rejected. Please resubmit or contact the office.', style: TextStyle(color: AppTheme.accent)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _radioStep(String label, bool done, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(done ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: done ? color : Colors.grey, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: done ? color : Colors.grey, fontWeight: done ? FontWeight.bold : FontWeight.normal, fontSize: 12)),
      ],
    );
  }
}
