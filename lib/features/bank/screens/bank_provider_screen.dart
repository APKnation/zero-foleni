import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

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
    {'id': '1', 'name': 'Teller: A. Juma'},
    {'id': '2', 'name': 'Teller: J. Mwamba'},
    {'id': '3', 'name': 'Teller: F. Hassan'},
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
    try {
      final data = await ApiService.getTellers(branchId: widget.branchId);
      if (mounted) {
        setState(() {
          _providers = data.isNotEmpty ? List<Map<String, dynamic>>.from(data) : List.from(_fallbackProviders);
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
        leading: BackButton(onPressed: () => context.go('/bank-services/${widget.bankId}/${widget.branchId}')),
        title: const Text('Select Teller'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _providers.length,
              itemBuilder: (_, i) {
                final p = _providers[i];
                final providerId = p['id']?.toString() ?? '${i + 1}';
                final name = p['name']?.toString() ?? p.toString();
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: Icon(Icons.person, color: AppTheme.background),
                    ),
                    title: Text(name),
                    subtitle: const Text('Available'),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
                    onTap: () => context.go('/bank-booking/${widget.bankId}/${widget.branchId}/${widget.serviceId}/$providerId'),
                  ),
                );
              },
            ),
    );
  }
}
