import 'package:storage/storage.dart';

class VolumeModel {
  final String path;
  final MediaState state;
  final bool isEmulated;
  final bool isPrimary;
  final bool isRemovable;

  VolumeModel({
    required this.path,
    required this.state,
    required this.isEmulated,
    required this.isPrimary,
    required this.isRemovable,
  });

  VolumeModel copyWith({
    MediaState? state,
  }) {
    return VolumeModel(
      path: path,
      state: state ?? this.state,
      isEmulated: isEmulated,
      isPrimary: isPrimary,
      isRemovable: isRemovable,
    );
  }
}
