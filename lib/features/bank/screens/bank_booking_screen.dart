import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class BankBookingScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  final String serviceId;
  final String providerId;
  const BankBookingScreen({
    super.key,
    required this.bankId,
    required this.branchId,
    required this.serviceId,
    required this.providerId,
  });

  @override
  State<BankBookingScreen> createState() => _BankBookingScreenState();
}

class _BankBookingScreenState extends State<BankBookingScreen> {
  DateTime? date;
  String? time;
  bool _submitting = false;

  Future<void> _confirmBooking() async {
    setState(() => _submitting = true);

    try {
      // 1. Create Bank Ticket
      final res = await ApiService.createBankTicket(
        bankId: widget.bankId,
        branchId: widget.branchId,
        serviceId: widget.serviceId,
        tellerId: widget.providerId,
      );

      // 2. If appointment date was selected, also book appointment
      if (date != null && time != null) {
        await ApiService.bookBankAppointment(
          bankId: widget.bankId,
          branchId: widget.branchId,
          serviceId: widget.serviceId,
          date: date!.toLocal().toString().split(' ').first,
          time: time!,
        );
      }

      if (mounted) {
        setState(() => _submitting = false);
        final ticket = res['ticket'] as Map<String, dynamic>?;
        if (ticket != null) {
          ApiService.latestBankTicket = ticket;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Ombi limefanikiwa!'),
            backgroundColor: res['success'] == true ? AppTheme.primary : AppTheme.accent,
          ),
        );
        context.go('/bank-ticket');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        context.go('/bank-ticket');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(date == null ? 'Chagua Tarehe (Select date)' : 'Tarehe: ${date!.toLocal().toString().split(' ').first}'),
              trailing: const Icon(Icons.calendar_today, color: AppTheme.accent),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppTheme.secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (d != null) setState(() => date = d);
              },
            ),
            const SizedBox(height: 16),
            const Text('Chagua Muda unaotaka (Select Time):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['09:00', '10:00', '11:00', '14:00', '15:00']
                  .map((t) => ChoiceChip(
                        label: Text(t),
                        selected: time == t,
                        onSelected: (_) => setState(() => time = t),
                      ))
                  .toList(),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _submitting ? null : _confirmBooking,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.background),
                    )
                  : const Text('Thibitisha & Pata Tiketi (Confirm Booking)'),
            ),
          ],
        ),
      ),
    );
  }
}
