import 'package:flutter/material.dart';
import 'package:storage/storage.dart';

void main() {
  runApp(const MyApp());

  final storageManager = StorageManager();
  storageManager.mediaChanged.listen((event) {
    debugPrint('Media changed: ${event.action}, ${event.path}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Storage Example'),
        ),
      ),
    );
  }
}
