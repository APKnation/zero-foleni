import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankBranchScreen extends StatefulWidget {
  final String bankId;
  const BankBranchScreen({super.key, required this.bankId});

  @override
  State<BankBranchScreen> createState() => _BankBranchScreenState();
}

class _BankBranchScreenState extends State<BankBranchScreen> {
  static const _fallbackBranches = [
    {'id': '1', 'name': 'City Centre Branch', 'location': 'Samora Avenue'},
    {'id': '2', 'name': 'Ubungo Branch', 'location': 'Morogoro Road'},
    {'id': '3', 'name': 'Kariakoo Branch', 'location': 'Msimbazi Street'},
    {'id': '4', 'name': 'Mikocheni Branch', 'location': 'Old Bagamoyo Road'},
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
    final data = await ApiService.getBranches(widget.bankId);
    if (mounted) {
      setState(() {
        _branches = data.isNotEmpty ? data : List.from(_fallbackBranches);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Branch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadBranches,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _branches.length,
              itemBuilder: (_, i) {
                final br = _branches[i];
                final branchId = br['id']?.toString() ?? '1';
                return ListTile(
                  leading: const Icon(Icons.location_city, color: Colors.blue),
                  title: Text(br['name'] ?? ''),
                  subtitle: br['location'] != null && (br['location'] as String).isNotEmpty
                      ? Text(br['location'])
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/bank-services/${widget.bankId}/$branchId'),
                );
              },
            ),
    );
  }
}
