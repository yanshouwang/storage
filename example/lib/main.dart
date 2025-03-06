import 'package:flutter/material.dart';
import 'package:storage/storage.dart';

import 'models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final StorageManager _storageManager;
  late final ValueNotifier<List<VolumeModel>> _volumeModels;

  @override
  void initState() {
    super.initState();
    _storageManager = StorageManager();
    _volumeModels = ValueNotifier([]);
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Example'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _volumeModels,
        builder: (context, volumeModels, child) {
          return ListView.separated(
            itemBuilder: (context, i) {
              final volumeModel = volumeModels[i];
              final path = volumeModel.path;
              final state = volumeModel.state.name;
              final isEmulated = volumeModel.isEmulated ? 'Emulated' : '';
              final isPrimary = volumeModel.isPrimary ? 'Primary' : '';
              final isRemovable = volumeModel.isRemovable ? 'Removable' : '';
              return Row(
                spacing: 4.0,
                children: [
                  Text(path),
                  Text(state),
                  Text(isEmulated),
                  Text(isPrimary),
                  Text(isRemovable),
                ],
              );
            },
            separatorBuilder: (context, i) {
              return const Divider();
            },
            itemCount: volumeModels.length,
          );
        },
      ),
    );
  }

  void _initialize() async {
    final volumes = await _storageManager.getStorageVolumes();
    final newValue = <VolumeModel>[];
    for (var volume in volumes) {
      final path = await volume.getPath().then((e) => e ?? '');
      final state = await volume.getState();
      final isEmulated = await volume.isEmulated();
      final isPrimary = await volume.isPrimary();
      final isRemovable = await volume.isRemovable();
      final volumeModel = VolumeModel(
        volume: volume,
        path: path,
        state: state,
        isEmulated: isEmulated,
        isPrimary: isPrimary,
        isRemovable: isRemovable,
      );
      newValue.add(volumeModel);
    }
    _volumeModels.value = newValue;
    _storageManager.stateChanged.listen(_onVolumeStateChanged);
  }

  void _onVolumeStateChanged(StorageVolume volume) async {
    final path = await volume.getPath().then((e) => e ?? '');
    final state = await volume.getState();
    final isEmulated = await volume.isEmulated();
    final isPrimary = await volume.isPrimary();
    final isRemovable = await volume.isRemovable();
    debugPrint('onVolumeStateChanged: ${volume.hashCode}, $path, $state');
    final value = _volumeModels.value;
    final newValue = <VolumeModel>[];
    final index = value.indexWhere((e) => e.volume == volume);
    if (index < 0) {
      newValue.addAll(value);
      final volumeModel = VolumeModel(
        volume: volume,
        path: path,
        state: state,
        isEmulated: isEmulated,
        isPrimary: isPrimary,
        isRemovable: isRemovable,
      );
      newValue.add(volumeModel);
    } else {
      for (var i = 0; i < value.length; i++) {
        final volumeModel = i == index
            ? value[i].copyWith(
                path: path,
                state: state,
              )
            : value[i];
        newValue.add(volumeModel);
      }
    }
    _volumeModels.value = newValue;
  }
}
