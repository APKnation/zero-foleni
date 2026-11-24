import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankTicketScreen extends StatelessWidget {
  const BankTicketScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: () => context.go('/home')), title: const Text('Queue Ticket')),
    body: Center(child: Card(margin: const EdgeInsets.all(24), child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('Ticket #3321', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('NMB Bank'),
      const Text('Cash Deposit'),
      const Text('Teller: A. Juma'),
      const Text('Time: 10:30 AM'),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.go('/bank-tracking'),
            icon: const Icon(Icons.remove),
            label: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.go('/bank-reschedule'),
            icon: const Icon(Icons.schedule),
            label: const Text('Reschedule'),
          ),
        ),
      ]),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => context.go('/bank-tracking'), child: const Text('Track Queue')),
    ])))),
  );
}

class BankRescheduleScreen extends StatefulWidget {
  const BankRescheduleScreen({super.key});
  @override
  State<BankRescheduleScreen> createState() => _BankRescheduleScreenState();
}

class _BankRescheduleScreenState extends State<BankRescheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _reschedule() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: Call API rescheduleAppointment mutation
    if (context.mounted) {
      context.pop();
      context.go('/bank-tracking');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.go('/bank-ticket')), title: const Text('Reschedule Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(children: [
            const Text('Reschedule Ticket #3321', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'New Date'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                if (picked != null) {
                  setState(() => _dateController.text = picked.toLocal().toString().split(' ').first);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'New Time'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (picked != null) {
                  setState(() => _timeController.text = picked.format(context));
                }
              },
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : FilledButton(onPressed: _reschedule, child: const Text('Reschedule')),
          ]),
        ),
      ),
    );
  }
}

class BankTicketDetailScreen extends StatelessWidget {
  const BankTicketDetailScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ticket Details')),
    body: const Padding(padding: EdgeInsets.all(24), child: Column(children: [
      Text('Ticket #3321', style: TextStyle(fontSize: 24)),
      SizedBox(height: 8),
      Text('NMB Bank'),
      SizedBox(height: 8),
      Text('Cash Deposit'),
      SizedBox(height: 8),
      Text('Teller: A. Juma'),
      SizedBox(height: 8),
      Text('Position: 3'),
      SizedBox(height: 8),
      Text('Status: Waiting'),
    ])),
  );
}

class BankTrackingScreen extends StatelessWidget {
  const BankTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: () => context.go('/bank-ticket')), title: const Text('Queue Tracking')),
    body: const Padding(padding: EdgeInsets.all(24), child: Column(children: [
      Text('Position: 3', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('Customers ahead: 2'),
      Text('Estimated wait: 15 min'),
    ])),
  );
}