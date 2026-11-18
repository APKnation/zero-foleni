import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankServiceScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  const BankServiceScreen({super.key, required this.bankId, required this.branchId});

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
    final data = await ApiService.getBankServices(widget.branchId);
    if (mounted) {
      setState(() {
        _services = data.isNotEmpty ? data : List.from(_fallbackServices);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Service'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadServices,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _services.length,
              itemBuilder: (_, i) {
                final s = _services[i];
                final serviceId = s['id']?.toString() ?? '1';
                return ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: Text(s['name'] ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(
                    '/bank-providers/${widget.bankId}/${widget.branchId}/$serviceId',
                  ),
                );
              },
            ),
    );
  }
}
