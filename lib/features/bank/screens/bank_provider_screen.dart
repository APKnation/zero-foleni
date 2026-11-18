import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankProviderScreen extends StatefulWidget {
  final String bankId;
  final String branchId;
  final String serviceId;
  const BankProviderScreen({
    Key? key,
    required this.bankId,
    required this.branchId,
    required this.serviceId,
  }) : super(key: key);

  @override
  _BankProviderScreenState createState() => _BankProviderScreenState();
}

class _BankProviderScreenState extends State<BankProviderScreen> {
  static const _fallbackProviders = ['Teller: A. Juma', 'Teller: J. Mwamba', 'Teller: F. Hassan'];
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
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Teller')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _providers.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.person),
                title: Text(_providers[i]['name'] as String),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pop(),
              ),
            ),
      ),
    );
  }
}