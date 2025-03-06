import 'dart:async';

import 'media_state.dart';
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
    return volumes.map((volume) => volume.obj).toList();
  }

  void _onListenStateChanged() async {
    final manager = await _manager;
    final executor = await api.ContextCompat.getMainExecutor(_context);
    final callback = api.StorageVolumeCallback(onStateChanged: (_, volume) {
      _stateChangedController.add(volume.obj);
    });
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
  final api.StorageVolume _volume;

  _StorageVolumeImpl.impl(this._volume) : super.impl();

  @override
  Future<String?> getPath() async {
    final path = await _volume.getPath();
    if (path == null) {
      return null;
    }
    return path;
  }

  @override
  Future<MediaState> getState() async {
    final state = await _volume.getState();
    return state.obj;
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
}

extension on api.StorageVolume {
  StorageVolume get obj => _StorageVolumeImpl.impl(this);
}

extension on api.MediaState {
  MediaState get obj {
    switch (this) {
      case api.MediaState.unknown:
        return MediaState.unknown;
      case api.MediaState.removed:
        return MediaState.removed;
      case api.MediaState.unmounted:
        return MediaState.unmounted;
      case api.MediaState.checking:
        return MediaState.checking;
      case api.MediaState.nofs:
        return MediaState.nofs;
      case api.MediaState.mounted:
        return MediaState.mounted;
      case api.MediaState.mountedReadOnly:
        return MediaState.mountedReadOnly;
      case api.MediaState.shared:
        return MediaState.shared;
      case api.MediaState.badRemoval:
        return MediaState.badRemoval;
      case api.MediaState.unmountable:
        return MediaState.unmountable;
      case api.MediaState.ejecting:
        return MediaState.ejecting;
    }
  }
}
