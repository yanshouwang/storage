import 'package:flutter/material.dart';
import 'package:storage/storage.dart';

void main() {
  runApp(const MyApp());

  test();
}

void test() async {
  final storageManager = StorageManager();
  final volumes = await storageManager.getStorageVolumes();
  for (var volume in volumes) {
    final volumePath = await volume.getPath();
    debugPrint('Volume: $volumePath');
  }
  // storageManager.mediaChanged.listen((event) {
  //   debugPrint('Media changed: ${event.action}, ${event.path}');
  // });
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
