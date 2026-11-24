import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class BookingScreen extends StatefulWidget {
  final String hospitalId;
  final String serviceId;
  const BookingScreen({super.key, required this.hospitalId, required this.serviceId});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? date;
  String? time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/services/${widget.hospitalId}')),
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Icon(Icons.calendar_today, color: AppTheme.background),
                ),
                title: Text(date == null ? 'Select date' : date!.toLocal().toString().split(' ').first),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
                  if (d != null) setState(() => date = d);
                },
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['09:00', '10:00', '11:00', '14:00']
                  .map((t) => ChoiceChip(
                        label: Text(t),
                        selected: time == t,
                        selectedColor: AppTheme.primary,
                        labelStyle: TextStyle(color: time == t ? AppTheme.background : AppTheme.secondary),
                        onSelected: (_) => setState(() => time = t),
                      ))
                  .toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: () => context.go('/ticket'), child: const Text('Confirm Booking')),
            ),
          ],
        ),
      ),
    );
  }
}
