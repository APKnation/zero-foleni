import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankTicketScreen extends StatelessWidget {
  const BankTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ticket = ApiService.latestBankTicket;
    final ticketNumber = ticket?['number'] ?? '3321';
    final position = ticket?['position'] ?? 1;
    final status = ticket?['status'] ?? 'waiting';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Ticket'),
        leading: BackButton(onPressed: () => context.go('/home')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.confirmation_number_outlined, size: 48, color: Colors.blue),
                  const SizedBox(height: 12),
                  Text(
                    'Ticket #$ticketNumber',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hali: $status',
                      style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 32),
                  _infoRow('Nafasi kwenye foleni:', 'Namba $position'),
                  _infoRow('Huduma:', 'Cash / General Banking'),
                  _infoRow('Muda uliokadiriwa:', 'Dakika ${position * 5}'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.track_changes),
                      label: const Text('Fuata Foleni (Track Queue)'),
                      onPressed: () => context.go('/bank-tracking'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Rudi Nyumbani'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class BankTrackingScreen extends StatefulWidget {
  const BankTrackingScreen({super.key});

  @override
  State<BankTrackingScreen> createState() => _BankTrackingScreenState();
}

class _BankTrackingScreenState extends State<BankTrackingScreen> {
  bool _refreshing = false;

  Future<void> _refresh() async {
    final ticket = ApiService.latestBankTicket;
    if (ticket != null && ticket['number'] != null) {
      setState(() => _refreshing = true);
      final updated = await ApiService.getBankTicket(ticket['number'].toString());
      if (mounted) {
        setState(() {
          _refreshing = false;
          if (updated != null) {
            ApiService.latestBankTicket = updated;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticket = ApiService.latestBankTicket;
    final position = ticket?['position'] ?? 3;
    final ahead = (position is int && position > 1) ? position - 1 : 0;
    final ticketNum = ticket?['number'] ?? '3321';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Queue Tracking'),
        leading: BackButton(onPressed: () => context.go('/home')),
        actions: [
          IconButton(
            icon: _refreshing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refreshing ? null : _refresh,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Tiketi #$ticketNum', style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 12),
            Text(
              'Nafasi: $position',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Watu walio mbele yako:'),
                        Text('$ahead', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Muda wa kusubiri:'),
                        Text('~Dakika ${position * 5}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: () => context.go('/home'),
              child: const Text('Rudi Nyumbani'),
            ),
          ],
        ),
      ),
    );
  }
}
