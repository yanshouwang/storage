import 'package:clover/clover.dart';
import 'package:storage/storage.dart';
import 'package:storage_example/models.dart';

class HomeViewModel extends ViewModel {
  final StorageManager _storageManager;
  final List<VolumeModel> _volumes;

  HomeViewModel()
      : _storageManager = StorageManager(),
        _volumes = [] {
    _initialize();
  }

  List<VolumeModel> get volumes => _volumes;

  void _initialize() async {
    final volumes = await _storageManager.getVolumes();
    for (var volume in volumes) {
      _onVolumeStateChanged(volume);
    }
    _storageManager.volumeStateChanged.listen(_onVolumeStateChanged);
  }

  void _onVolumeStateChanged(Volume volume) async {
    final path = await volume.getPath().then((e) => e ?? '');
    final state = await volume.getState();
    final isEmulated = await volume.isEmulated();
    final isPrimary = await volume.isPrimary();
    final isRemovable = await volume.isRemovable();
    final i = _volumes.indexWhere((e) => e.volume == volume);
    if (i < 0) {
      final value = VolumeModel(
        volume: volume,
        path: path,
        state: state,
        isEmulated: isEmulated,
        isPrimary: isPrimary,
        isRemovable: isRemovable,
      );
      _volumes.add(value);
    } else {
      _volumes[i] = _volumes[i].copyWith(
        path: path,
        state: state,
      );
    }
    notifyListeners();
  }
}
