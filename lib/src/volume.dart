import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'volume_state.dart';

abstract base class Volume extends PlatformInterface {
  static final _token = Object();

  Volume.impl() : super(token: _token);

  Future<String?> getPath();
  Future<VolumeState> getState();
  Future<bool> isEmulated();
  Future<bool> isPrimary();
  Future<bool> isRemovable();
}
