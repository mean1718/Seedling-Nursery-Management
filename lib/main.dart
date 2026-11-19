import 'package:flutter/material.dart';

void main() {
  runApp(const SeedlingNurseryApp());
}

class SeedlingNurseryApp extends StatelessWidget {
  const SeedlingNurseryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seedling Nursery Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Seedling Nursery Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
