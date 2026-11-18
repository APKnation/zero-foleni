import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';

class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  static const _fallbackBanks = [
    {'id': '1', 'name': 'NMB Bank', 'code': 'NMB'},
    {'id': '2', 'name': 'CRDB Bank', 'code': 'CRDB'},
    {'id': '3', 'name': 'NBC Bank', 'code': 'NBC'},
    {'id': '4', 'name': 'Stanbic Bank', 'code': 'STANBIC'},
    {'id': '5', 'name': 'Exim Bank', 'code': 'EXIM'},
    {'id': '6', 'name': 'Azania Bank', 'code': 'AZANIA'},
  ];

  List<Map<String, dynamic>> _banks = [];
  bool _loading = true;
  bool _isLive = false;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    setState(() => _loading = true);
    final data = await ApiService.banks();
    if (mounted) {
      if (data.isNotEmpty) {
        setState(() {
          _banks = List<Map<String, dynamic>>.from(data);
          _isLive = true;
          _loading = false;
        });
      } else {
        setState(() {
          _banks = List.from(_fallbackBanks);
          _isLive = false;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadBanks,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: _isLive ? Colors.green.shade50 : Colors.orange.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        _isLive ? Icons.check_circle : Icons.info,
                        size: 16,
                        color: _isLive ? Colors.green.shade700 : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isLive
                            ? 'Mabenki yamepakiwa kutoka Backend (Live Database)'
                            : 'Mabenki yamepakiwa toleo la ndani (Offline/Fallback)',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isLive ? Colors.green.shade800 : Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _banks.length,
                    itemBuilder: (_, i) {
                      final b = _banks[i];
                      final bankId = b['id']?.toString() ?? '1';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(Icons.account_balance, color: Colors.blue),
                        ),
                        title: Text(b['name'] ?? ''),
                        subtitle: b['code'] != null && (b['code'] as String).isNotEmpty
                            ? Text('Code: ${b['code']}')
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/bank-branches/$bankId'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
