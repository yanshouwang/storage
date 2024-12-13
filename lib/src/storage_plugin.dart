import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'impl.dart';
import 'storage_manager.dart';

abstract class StoragePlugin extends PlatformInterface {
  /// Constructs a StoragePlatform.
  StoragePlugin() : super(token: _token);

  static final Object _token = Object();

  static StoragePlugin? _instance;

  /// The default instance of [StoragePlugin] to use.
  ///
  /// Defaults to [MethodChannelStorage].
  static StoragePlugin get instance {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = StoragePluginImpl();
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StoragePlugin] when
  /// they register themselves.
  static set instance(StoragePlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  StorageManager get storageManager;
}
