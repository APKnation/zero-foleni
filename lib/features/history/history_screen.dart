import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(leading: const BackButton(), title: const Text('History')), body: const Center(child: Text('Booking History')));
}
