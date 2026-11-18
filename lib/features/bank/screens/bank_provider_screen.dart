import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankProviderScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  final String serviceId;
  const BankProviderScreen({
    super.key,
    required this.bankId,
    required this.branchId,
    required this.serviceId,
  });

  @override
  State<BankProviderScreen> createState() => _BankProviderScreenState();
}

class _BankProviderScreenState extends State<BankProviderScreen> {
  static const _fallbackProviders = [
    {'id': '1', 'name': 'Teller: A. Juma', 'available': true},
    {'id': '2', 'name': 'Teller: J. Mwamba', 'available': true},
    {'id': '3', 'name': 'Teller: F. Hassan', 'available': true},
  ];

  List<Map<String, dynamic>> _providers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _loading = true);
    final data = await ApiService.getTellers(widget.branchId);
    if (mounted) {
      setState(() {
        _providers = data.isNotEmpty ? data : List.from(_fallbackProviders);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Teller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadProviders,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _providers.length,
              itemBuilder: (_, i) {
                final p = _providers[i];
                final providerId = p['id']?.toString() ?? '1';
                return ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueGrey),
                  title: Text(p['name'] ?? ''),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(
                    '/bank-booking/${widget.bankId}/${widget.branchId}/${widget.serviceId}/$providerId',
                  ),
                );
              },
            ),
    );
  }
}
