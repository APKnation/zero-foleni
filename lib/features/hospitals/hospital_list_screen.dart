import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Hospitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: HospitalSearchDelegate(hospitals)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: hospitals.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.local_hospital, color: AppTheme.background),
            ),
            title: Text(hospitals[i]),
            subtitle: const Text('Dar es Salaam'),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: () => context.go('/services/h$i'),
          ),
        ),
      ),
    );
  }
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
