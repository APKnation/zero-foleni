import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/home')),
        title: const Text('Universities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: UniversitySearchDelegate(unis)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: unis.length,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.school, color: AppTheme.background),
            ),
            title: Text(unis[i]),
            subtitle: const Text('Tanzania'),
            trailing: const Icon(Icons.chevron_right, color: AppTheme.primary),
            onTap: () => context.go('/uni-services/u$i'),
          ),
        ),
      ),
    );
  }
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
