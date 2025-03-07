import 'dart:async';

import 'volume_state.dart';
import 'storage.g.dart' as api;
import 'storage_manager.dart';
import 'storage_plugin.dart';
import 'volume.dart';

api.Context get _context => api.StoragePlugin.instance.context;

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
  late final StreamController<Volume> _volumeStateChangedController;
  api.StorageEventListener? _storageEventListener;

  _StorageManagerImpl._impl()
      : _manager = api.ContextCompat.getStorageManager(_context)
            .then((manager) => ArgumentError.checkNotNull(manager)),
        super.impl() {
    _volumeStateChangedController = StreamController.broadcast(
      onListen: _onListenStateChanged,
      onCancel: _onCancelStateChanged,
    );
  }

  @override
  Stream<Volume> get volumeStateChanged => _volumeStateChangedController.stream;

  @override
  Future<List<Volume>> getVolumes() async {
    final manager = await _manager;
    final volumes = await manager.getVolumes();
    final volumeObjs = <Volume>[];
    for (var volume in volumes) {
      final id = await volume.getId();
      final volumeObj = _VolumeImpl.impl(id, volume);
      volumeObjs.add(volumeObj);
    }
    return volumeObjs;
  }

  void _onListenStateChanged() async {
    final manager = await _manager;
    final listener = api.StorageEventListener(
      onVolumeStateChanged: (_, volume, oldState, newState) async {
        final id = await volume.getId();
        final volumeObj = _VolumeImpl.impl(id, volume);
        _volumeStateChangedController.add(volumeObj);
      },
    );
    await manager.registerListener(listener);
    _storageEventListener = listener;
  }

  void _onCancelStateChanged() async {
    final manager = await _manager;
    final listener = _storageEventListener;
    if (listener == null) {
      return;
    }
    await manager.unregisterListener(listener);
  }
}

final class _VolumeImpl extends Volume {
  final String _id;
  final api.Volume _volume;

  _VolumeImpl.impl(this._id, this._volume) : super.impl();

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
    return other is _VolumeImpl && other._id == _id;
  }
}
