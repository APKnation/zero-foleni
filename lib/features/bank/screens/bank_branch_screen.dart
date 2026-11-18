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
    {'name': 'City Centre Branch', 'location': 'Samora Avenue, Dar es Salaam'},
    {'name': 'Ubungo Branch', 'location': 'Morogoro Road, Dar es Salaam'},
    {'name': 'Kariakoo Branch', 'location': 'Msimbazi Street, Dar es Salaam'},
    {'name': 'Mikocheni Branch', 'location': 'Old Bagamoyo Road, Dar es Salaam'},
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
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Branch')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _branches.length,
              itemBuilder: (_, i) => ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(_branches[i]['name']),
                subtitle: Text(_branches[i]['location']),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pop(_branches[i]['name']),
              ),
            ),
      );
  }
}