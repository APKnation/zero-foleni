import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankServiceScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  const BankServiceScreen({
    Key? key,
    required this.bankId,
    required this.branchId,
  }) : super(key: key);

  @override
  _BankServiceScreenState createState() => _BankServiceScreenState;
}

class _BankServiceScreenState extends State<BankServiceScreen> {
  static const _fallbackServices = ['Account Opening', 'Cash Deposit', 'Cash Withdrawal', 'Money Transfer', 'Loan Services', 'ATM Card Services', 'Customer Support'];
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
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Service')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _services.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text(_services[i]['name'] as String),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pop(),
              ),
            ),
      ),
    );
  }
}