import 'package:storage/storage.dart';

class VolumeModel {
  final Volume volume;

  final String path;
  final VolumeState state;
  final bool isEmulated;
  final bool isPrimary;
  final bool isRemovable;

  VolumeModel({
    required this.volume,
    required this.path,
    required this.state,
    required this.isEmulated,
    required this.isPrimary,
    required this.isRemovable,
  });

  VolumeModel copyWith({
    String? path,
    VolumeState? state,
  }) {
    return VolumeModel(
      volume: volume,
      path: path ?? this.path,
      state: state ?? this.state,
      isEmulated: isEmulated,
      isPrimary: isPrimary,
      isRemovable: isRemovable,
    );
  }
}
