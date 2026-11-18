import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UniversityServiceScreen extends StatelessWidget {
  final String uniId;
  const UniversityServiceScreen({super.key, required this.uniId});
  static const services = ['Admissions and Registration','Academic Records and Examinations','Finance and Payments','Student Affairs','ICT Support','Library Services','Accommodation and Hostel Services','Clearance and Graduation'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University Services')),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.business),
          title: Text(services[i]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/uni-ticket'),
        ),
      ),
    );
  }
}
