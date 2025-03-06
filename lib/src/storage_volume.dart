import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'media_state.dart';

abstract base class StorageVolume extends PlatformInterface {
  static final _token = Object();

  StorageVolume.impl() : super(token: _token);

  Future<String?> getPath();
  Future<MediaState> getState();
  Future<bool> isEmulated();
  Future<bool> isPrimary();
  Future<bool> isRemovable();
}
