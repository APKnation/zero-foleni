import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UniversityListScreen extends StatelessWidget {
  const UniversityListScreen({super.key});
  static const unis = [
    'University of Dar es Salaam',
    'Ardhi University',
    'Mzumbe University',
    'Sokoine University',
    'St. Augustine University of Tanzania',
    'Open University of Tanzania',
  ];
  @override
  Widget build(BuildContext context) {
    final filtered = _filter.isNotEmpty
        ? unis.where((u) => u.toLowerCase().contains(_filter.toLowerCase())).toList()
        : unis;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: UniversitySearchDelegate(unis)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.school),
          title: Text(filtered[i]),
          subtitle: const Text('Tanzania'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/uni-services/u$i'),
        ),
      ),
    );
  }
  
  String get _filter => '';
}

class UniversitySearchDelegate extends SearchDelegate<String> {
  final List<String> options;
  UniversitySearchDelegate(this.options);
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