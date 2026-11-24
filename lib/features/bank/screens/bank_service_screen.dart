import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class BankServiceScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  const BankServiceScreen({
    super.key,
    required this.bankId,
    required this.branchId,
  });

  @override
  State<BankServiceScreen> createState() => _BankServiceScreenState();
}

class _BankServiceScreenState extends State<BankServiceScreen> {
  static const _fallbackServices = [
    {'id': '1', 'name': 'Account Opening'},
    {'id': '2', 'name': 'Cash Deposit'},
    {'id': '3', 'name': 'Cash Withdrawal'},
    {'id': '4', 'name': 'Money Transfer'},
    {'id': '5', 'name': 'Loan Services'},
    {'id': '6', 'name': 'ATM Card Services'},
    {'id': '7', 'name': 'Customer Support'},
  ];

  List<Map<String, dynamic>> _services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getBankServices(branchId: widget.branchId);
      if (mounted) {
        setState(() {
          _services = data.isNotEmpty ? List<Map<String, dynamic>>.from(data) : List.from(_fallbackServices);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/bank-branches/${widget.bankId}')),
        title: const Text('Select Service'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _services.length,
              itemBuilder: (_, i) {
                final s = _services[i];
                final serviceId = s['id']?.toString() ?? '${i + 1}';
                final name = s['name']?.toString() ?? s.toString();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: Icon(Icons.attach_money, color: AppTheme.background),
                    ),
                    title: Text(name),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
                    onTap: () => context.go('/bank-providers/${widget.bankId}/${widget.branchId}/$serviceId'),
                  ),
                );
              },
            ),
    );
  }
}
