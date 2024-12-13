import 'dart:async';

import 'package:jni/jni.dart' as jni;

import 'events.dart';
import 'jni.dart' as jni;
import 'media_action.dart';
import 'storage_manager.dart';
import 'storage_plugin.dart';

final class StoragePluginImpl extends StoragePlugin {
  @override
  StorageManager get storageManager => StorageManagerImpl();
}

final class StorageManagerImpl implements StorageManager {
  static StorageManagerImpl? _instance;

  late final jni.BroadcastReceiverImpl _receiver;
  late final StreamController<MediaChangedEvent> _mediaChangedController;

  StorageManagerImpl._() {
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

  factory StorageManagerImpl() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = StorageManagerImpl._();
    }
    return instance;
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
