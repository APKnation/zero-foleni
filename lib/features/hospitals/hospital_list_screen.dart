import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HospitalListScreen extends StatelessWidget {
  const HospitalListScreen({super.key});
  static const hospitals = [
    'Muhimbili National Hospital',
    'Aga Khan Hospital',
    'Ocean Road Cancer Institute',
    'Amana Regional Hospital',
    'Mloganzila Hospital',
    'Temeke Hospital',
    'Kinondoni Hospital',
    'Ilala Hospital',
  ];
  @override
  Widget build(BuildContext context) {
    final filtered = _filter.isNotEmpty
        ? hospitals.where((h) => h.toLowerCase().contains(_filter.toLowerCase())).toList()
        : hospitals;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: HospitalSearchDelegate(hospitals)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.local_hospital),
          title: Text(filtered[i]),
          subtitle: const Text('Dar es Salaam'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/services/h$i'),
        ),
      ),
    );
  }
  
  String get _filter => '';
}

class HospitalSearchDelegate extends SearchDelegate<String> {
  final List<String> options;
  HospitalSearchDelegate(this.options);
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
    itemCount: options.length,
    itemBuilder: (_, i) => ListTile(
      title: Text(options[i]),
      onTap: () => close(context, options[i]),
    ),
  );
  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(options[i]),
        onTap: () => close(context, options[i]),
      ),
    );
  }
}