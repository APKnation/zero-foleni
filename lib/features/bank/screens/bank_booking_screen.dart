import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankBookingScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  final String serviceId;
  final String providerId;
  const BankBookingScreen({super.key, required this.bankId, required this.branchId, required this.serviceId, required this.providerId});
  @override
  State<BankBookingScreen> createState() => _BankBookingScreenState();
}

class _BankBookingScreenState extends State<BankBookingScreen> {
  DateTime? date;
  String? time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(date == null ? 'Select date' : date!.toLocal().toString().split(' ').first),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                if (d != null) setState(() => date = d);
              },
            ),
            Wrap(spacing: 8, children: ['09:00','10:00','11:00','14:00','15:00'].map((t) => ChoiceChip(label: Text(t), selected: time==t, onSelected: (_) => setState(() => time=t))).toList()),
            const Spacer(),
            FilledButton(onPressed: () => context.go('/bank-ticket'), child: const Text('Confirm Booking')),
          ],
        ),
      ),
    );
  }
}
