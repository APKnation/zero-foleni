import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class GovernmentListScreen extends StatefulWidget {
  const GovernmentListScreen({super.key});
  @override
  State<GovernmentListScreen> createState() => _GovernmentListScreenState();
}

class _GovernmentListScreenState extends State<GovernmentListScreen> {
  final List<String> _offices = [
    'NIDA – National Identification',
    'BRELA – Business Registration',
    'TRA – Taxpayer Services',
    'RITA – Birth, Marriage & Death',
    'Immigration Office',
    'Local Government Ward Office',
  ];
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _filter.isNotEmpty
        ? _offices.where((o) => o.toLowerCase().contains(_filter.toLowerCase())).toList()
        : _offices;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Government Offices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: GovernmentSearchDelegate(_offices)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filtered.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.account_balance, color: AppTheme.background),
            ),
            title: Text(filtered[i]),
            subtitle: const Text('Tanzania'),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: () => context.go('/gov-services/g$i'),
          ),
        ),
      ),
    );
  }
}

class GovernmentSearchDelegate extends SearchDelegate<String> {
  final List<String> options;
  GovernmentSearchDelegate(this.options);
  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.close), onPressed: () => query = ''),
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );
  @override
  Widget buildResults(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: options.length,
    itemBuilder: (_, i) => Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(options[i]),
        onTap: () => close(context, options[i]),
      ),
    ),
  );
  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: options.length,
      itemBuilder: (_, i) => Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(options[i]),
          onTap: () => close(context, options[i]),
        ),
      ),
    );
  }
}
