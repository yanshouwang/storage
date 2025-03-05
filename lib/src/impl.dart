import 'dart:async';

import 'package:jni/jni.dart' as jni;

import 'events.dart';
import 'jni.dart' as jni;
import 'media_action.dart';
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

  final Future<api.StorageManager?> _manager;

  _StorageManagerImpl._impl()
      : _manager = api.ContextCompat.getStorageManager(_context),
        super.impl();

  @override
  // TODO: implement mediaChanged
  Stream<MediaChangedEvent> get mediaChanged => throw UnimplementedError();

  @override
  Future<List<StorageVolume>> getStorageVolumes() async {
    final manager = await _manager;
    if (manager == null) {
      throw ArgumentError.notNull();
    }
    final volumes = await manager.getStorageVolumes();
    return volumes.map((volume) => _StorageVolumeImpl.impl(volume)).toList();
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
}

final class _JNIStorageManagerImpl extends StorageManager {
  static _JNIStorageManagerImpl? _instance;

  factory _JNIStorageManagerImpl() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = _JNIStorageManagerImpl._impl();
    }
    return instance;
  }

  late final jni.BroadcastReceiverImpl _receiver;
  late final StreamController<MediaChangedEvent> _mediaChangedController;

  _JNIStorageManagerImpl._impl() : super.impl() {
    final callback = jni.BroadcastReceiverImpl_Callback.implement(
      jni.$BroadcastReceiverImpl_Callback(
        onReceive: (context, intent) {
          final action = intent.getAction().toAction();
          final jPath = intent.getDataString();
          final path = jPath.isNull
              ? null
              : jPath.toDartString(
                  releaseOriginal: true,
                );
          final event = MediaChangedEvent(
            action: action,
            path: path,
          );
          _mediaChangedController.add(event);
        },
      ),
    );
    _receiver = jni.BroadcastReceiverImpl(callback);
    _mediaChangedController = StreamController.broadcast(
      onListen: _onListenMediaChanged,
      onCancel: _onCancelMediaChanged,
    );
  }

  @override
  Stream<MediaChangedEvent> get mediaChanged => _mediaChangedController.stream;

  void _onListenMediaChanged() {
    final filter = jni.IntentFilter()
      ..addDataScheme(jni.ContentResolver.SCHEME_FILE)
      ..addAction(jni.Intent.ACTION_MEDIA_BAD_REMOVAL)
      ..addAction(jni.Intent.ACTION_MEDIA_BUTTON)
      ..addAction(jni.Intent.ACTION_MEDIA_CHECKING)
      ..addAction(jni.Intent.ACTION_MEDIA_EJECT)
      ..addAction(jni.Intent.ACTION_MEDIA_MOUNTED)
      ..addAction(jni.Intent.ACTION_MEDIA_NOFS)
      ..addAction(jni.Intent.ACTION_MEDIA_REMOVED)
      ..addAction(jni.Intent.ACTION_MEDIA_SCANNER_FINISHED)
      ..addAction(jni.Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
      ..addAction(jni.Intent.ACTION_MEDIA_SCANNER_STARTED)
      ..addAction(jni.Intent.ACTION_MEDIA_SHARED)
      ..addAction(jni.Intent.ACTION_MEDIA_UNMOUNTABLE)
      ..addAction(jni.Intent.ACTION_MEDIA_UNMOUNTED);
    jni.ContextCompat.registerReceiver(
      jni.context,
      _receiver,
      filter,
      jni.ContextCompat.RECEIVER_NOT_EXPORTED,
    );
  }

  void _onCancelMediaChanged() {
    jni.context.unregisterReceiver(_receiver);
  }

  @override
  Future<List<StorageVolume>> getStorageVolumes() {
    // TODO: implement getStorageVolumes
    throw UnimplementedError();
  }
}

extension on jni.JString {
  MediaAction toAction() {
    if (this == jni.Intent.ACTION_MEDIA_BAD_REMOVAL) {
      return MediaAction.badRemoval;
    }
    if (this == jni.Intent.ACTION_MEDIA_BUTTON) {
      return MediaAction.button;
    }
    if (this == jni.Intent.ACTION_MEDIA_CHECKING) {
      return MediaAction.checking;
    }
    if (this == jni.Intent.ACTION_MEDIA_EJECT) {
      return MediaAction.eject;
    }
    if (this == jni.Intent.ACTION_MEDIA_MOUNTED) {
      return MediaAction.mounted;
    }
    if (this == jni.Intent.ACTION_MEDIA_NOFS) {
      return MediaAction.nofs;
    }
    if (this == jni.Intent.ACTION_MEDIA_REMOVED) {
      return MediaAction.removed;
    }
    if (this == jni.Intent.ACTION_MEDIA_SCANNER_FINISHED) {
      return MediaAction.scannerFinished;
    }
    if (this == jni.Intent.ACTION_MEDIA_SCANNER_SCAN_FILE) {
      return MediaAction.scannerScanFile;
    }
    if (this == jni.Intent.ACTION_MEDIA_SCANNER_STARTED) {
      return MediaAction.scannerStarted;
    }
    if (this == jni.Intent.ACTION_MEDIA_SHARED) {
      return MediaAction.shared;
    }
    if (this == jni.Intent.ACTION_MEDIA_UNMOUNTABLE) {
      return MediaAction.unmountable;
    }
    if (this == jni.Intent.ACTION_MEDIA_UNMOUNTED) {
      return MediaAction.unmounted;
    }
    throw ArgumentError.value(this);
  }
}
