package dev.hebei.storage

import android.os.Build
import android.os.Environment
import android.os.storage.StorageVolume

class StorageVolumeApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiStorageVolume(registrar) {
    override fun getPath(pigeon_instance: StorageVolume): String? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            pigeon_instance.directory?.path
        } else {
            val method = StorageVolume::class.java.getMethod("getPath")
            return method.invoke(pigeon_instance) as String?
        }
    }

    override fun getState(pigeon_instance: StorageVolume): MediaState {
        return pigeon_instance.state.mediaStateArgs
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

val String.mediaStateArgs: MediaState
    get() = when (this) {
        Environment.MEDIA_BAD_REMOVAL -> MediaState.BAD_REMOVAL
        Environment.MEDIA_CHECKING -> MediaState.CHECKING
        Environment.MEDIA_EJECTING -> MediaState.EJECTING
        Environment.MEDIA_MOUNTED -> MediaState.MOUNTED
        Environment.MEDIA_MOUNTED_READ_ONLY -> MediaState.MOUNTED_READ_ONLY
        Environment.MEDIA_NOFS -> MediaState.NOFS
        Environment.MEDIA_REMOVED -> MediaState.REMOVED
        Environment.MEDIA_SHARED -> MediaState.SHARED
        Environment.MEDIA_UNMOUNTABLE -> MediaState.UNMOUNTABLE
        Environment.MEDIA_UNMOUNTED -> MediaState.UNMOUNTED
        else -> MediaState.UNKNOWN
    }