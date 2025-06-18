import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Ticket')),
      body: const Center(
        child: Text('Purchase Screen (Select Numbers Here)'),
      ),
    );
  }
}