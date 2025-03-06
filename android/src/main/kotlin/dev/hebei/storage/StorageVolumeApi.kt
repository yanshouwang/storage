package dev.hebei.storage

import android.util.Log

class StorageVolumeApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiStorageVolume(registrar) {
    override fun getPath(pigeon_instance: StorageVolume): String? {
        return pigeon_instance.path
    }

    override fun getState(pigeon_instance: StorageVolume): MediaState {
        Log.d("storage", "getState: ${pigeon_instance.hashCode()}, ${pigeon_instance.path}, ${pigeon_instance.state}")
        return pigeon_instance.state
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