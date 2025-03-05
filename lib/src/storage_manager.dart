import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'events.dart';
import 'storage_plugin.dart';
import 'storage_volume.dart';

abstract base class StorageManager extends PlatformInterface {
  static final _token = Object();

  StorageManager.impl() : super(token: _token);

  factory StorageManager() => StoragePlugin.instance.newStorageManager();

  Stream<MediaChangedEvent> get mediaChanged;

  Future<List<StorageVolume>> getStorageVolumes();
}
