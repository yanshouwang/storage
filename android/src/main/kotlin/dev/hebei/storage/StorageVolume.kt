package dev.hebei.storage

import android.os.Environment

class StorageVolume(private val obj: android.os.storage.StorageVolume) {
    val path: String? get() {
        val clazz = android.os.storage.StorageVolume::class.java
        val method = clazz.getMethod("getPath")
        return method.invoke(obj) as String?
    }
    val state get() = obj.state.mediaStateArgs
    val isEmulated get() = obj.isEmulated
    val isPrimary get() = obj.isPrimary
    val isRemovable get() = obj.isRemovable
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