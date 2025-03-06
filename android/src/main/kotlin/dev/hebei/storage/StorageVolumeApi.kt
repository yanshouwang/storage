package dev.hebei.storage

class StorageVolumeApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiStorageVolume(registrar) {
    override fun getId(pigeon_instance: StorageVolume): String {
        return pigeon_instance.id
    }

    override fun getPath(pigeon_instance: StorageVolume): String? {
        return pigeon_instance.path
    }

    override fun getState(pigeon_instance: StorageVolume): VolumeState {
        return pigeon_instance.state.stateArgs
    }

    override fun isEmulated(pigeon_instance: StorageVolume): Boolean {
        return pigeon_instance.isEmulated
    }

    override fun isPrimary(pigeon_instance: StorageVolume): Boolean {
        return pigeon_instance.isPrimary
    }

    override fun isRemovable(pigeon_instance: StorageVolume): Boolean {
        return pigeon_instance.isRemovable
    }
}

private val Int.stateArgs: VolumeState
    get() = when (this) {
        StorageVolume.STATE_UNMOUNTED -> VolumeState.UNMOUNTED
        StorageVolume.STATE_CHECKING -> VolumeState.CHECKING
        StorageVolume.STATE_MOUNTED -> VolumeState.MOUNTED
        StorageVolume.STATE_MOUNTED_READ_ONLY -> VolumeState.MOUNTED_READ_ONLY
        StorageVolume.STATE_FORMATTING -> VolumeState.FORMATTING
        StorageVolume.STATE_EJECTING -> VolumeState.EJECTING
        StorageVolume.STATE_UNMOUNTABLE -> VolumeState.UNMOUNTABLE
        StorageVolume.STATE_REMOVED -> VolumeState.REMOVED
        StorageVolume.STATE_BAD_REMOVAL -> VolumeState.BAD_REMOVAL
        else -> VolumeState.UNKNOWN
    }