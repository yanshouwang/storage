import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract base class StorageVolume extends PlatformInterface {
  static final _token = Object();

  StorageVolume.impl() : super(token: _token);

  Future<String?> getPath();
}
