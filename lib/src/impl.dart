import 'dart:async';

import 'volume_state.dart';
import 'storage.g.dart' as api;
import 'storage_manager.dart';
import 'storage_plugin.dart';
import 'storage_volume.dart';

api.Context get _context => api.StoragePlugin.instance.applicationContext;

final class StoragePluginImpl extends StoragePlugin {
  @override
  StorageManager newStorageManager() => _StorageManagerImpl();
}

final class _StorageManagerImpl extends StorageManager {
  static _StorageManagerImpl? _instance;

  factory _StorageManagerImpl() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = _StorageManagerImpl._impl();
    }
    return instance;
  }

  final Future<api.StorageManager> _manager;
  late final StreamController<StorageVolume> _stateChangedController;
  api.StorageVolumeCallback? _storageVolumeCallback;

  _StorageManagerImpl._impl()
      : _manager = api.ContextCompat.getStorageManager(_context)
            .then((manager) => ArgumentError.checkNotNull(manager)),
        super.impl() {
    _stateChangedController = StreamController.broadcast(
      onListen: _onListenStateChanged,
      onCancel: _onCancelStateChanged,
    );
  }

  @override
  Stream<StorageVolume> get stateChanged => _stateChangedController.stream;

  @override
  Future<List<StorageVolume>> getStorageVolumes() async {
    final manager = await _manager;
    final volumes = await manager.getStorageVolumes();
    final volumeObjs = <StorageVolume>[];
    for (var volume in volumes) {
      final id = await volume.getId();
      final volumeObj = _StorageVolumeImpl.impl(id, volume);
      volumeObjs.add(volumeObj);
    }
    return volumeObjs;
  }

  void _onListenStateChanged() async {
    final manager = await _manager;
    final executor = await api.ContextCompat.getMainExecutor(_context);
    final callback = api.StorageVolumeCallback(
      onStateChanged: (_, volume) async {
        final id = await volume.getId();
        final volumeObj = _StorageVolumeImpl.impl(id, volume);
        _stateChangedController.add(volumeObj);
      },
    );
    await manager.registerStorageVolumeCallback(executor, callback);
    _storageVolumeCallback = callback;
  }

  void _onCancelStateChanged() async {
    final manager = await _manager;
    final callback = _storageVolumeCallback;
    if (callback == null) {
      return;
    }
    await manager.unregisterStorageVolumeCallback(callback);
  }
}

final class _StorageVolumeImpl extends StorageVolume {
  final String _id;
  final api.StorageVolume _volume;

  _StorageVolumeImpl.impl(this._id, this._volume) : super.impl();

  @override
  Future<String?> getPath() async {
    final path = await _volume.getPath();
    if (path == null) {
      return null;
    }
    return path;
  }

  @override
  Future<VolumeState> getState() async {
    final state = await _volume.getState();
    return state;
  }

  @override
  Future<bool> isEmulated() async {
    final isEmulated = await _volume.isEmulated();
    return isEmulated;
  }

  @override
  Future<bool> isPrimary() async {
    final isPrimary = await _volume.isPrimary();
    return isPrimary;
  }

  @override
  Future<bool> isRemovable() async {
    final isRemovable = await _volume.isRemovable();
    return isRemovable;
  }

  @override
  int get hashCode => _id.hashCode;

  @override
  bool operator ==(Object other) {
    return other is _StorageVolumeImpl && other._id == _id;
  }
}
