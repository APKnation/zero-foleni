import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../../core/theme/app_theme.dart';

class BankBranchScreen extends StatefulWidget {
  final String bankId;
  const BankBranchScreen({super.key, required this.bankId});

  @override
  State<BankBranchScreen> createState() => _BankBranchScreenState();
}

class _BankBranchScreenState extends State<BankBranchScreen> {
  static const _fallbackBranches = [
    {'id': '1', 'name': 'City Centre Branch', 'location': 'Samora Avenue, Dar es Salaam'},
    {'id': '2', 'name': 'Ubungo Branch', 'location': 'Morogoro Road, Dar es Salaam'},
    {'id': '3', 'name': 'Kariakoo Branch', 'location': 'Msimbazi Street, Dar es Salaam'},
    {'id': '4', 'name': 'Mikocheni Branch', 'location': 'Old Bagamoyo Road, Dar es Salaam'},
  ];

  List<Map<String, dynamic>> _branches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getBranches(bankId: widget.bankId);
      if (mounted) {
        setState(() {
          _branches = data.isNotEmpty ? List<Map<String, dynamic>>.from(data) : List.from(_fallbackBranches);
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
        leading: BackButton(onPressed: () => context.go('/bank')),
        title: const Text('Select Branch'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _branches.length,
              itemBuilder: (_, i) {
                final b = _branches[i];
                final branchId = b['id']?.toString() ?? '${i + 1}';
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: Icon(Icons.location_city, color: AppTheme.background),
                    ),
                    title: Text(b['name'] ?? ''),
                    subtitle: Text(b['location'] ?? ''),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
                    onTap: () => context.go('/bank-services/${widget.bankId}/$branchId'),
                  ),
                );
              },
            ),
    );
  }
}
