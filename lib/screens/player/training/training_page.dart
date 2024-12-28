import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Sessions'),
      ),
      body: Center(
        child: Text(
          'Training creation interface for coaches will be here.',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
