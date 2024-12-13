import 'events.dart';
import 'storage_plugin.dart';

abstract interface class StorageManager {
  factory StorageManager() => StoragePlugin.instance.storageManager;

  Stream<MediaChangedEvent> get mediaChanged;
}
