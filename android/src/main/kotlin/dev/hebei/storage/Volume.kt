package dev.hebei.storage

import android.annotation.SuppressLint
import android.content.Context

class Volume(private val obj: Any, private val context: Context) {
    companion object {
        @SuppressLint("PrivateApi")
        val clazz: Class<*> = Class.forName("android.os.storage.VolumeInfo")

        val ID_EMULATED_INTERNAL = clazz.getField("ID_EMULATED_INTERNAL").get(null) as String

        const val TYPE_PUBLIC = 0
        const val TYPE_PRIVATE = 1
        const val TYPE_EMULATED = 2
        const val TYPE_ASEC = 3
        const val TYPE_OBB = 4
        const val TYPE_STUB = 5

        const val STATE_UNMOUNTED = 0
        const val STATE_CHECKING = 1
        const val STATE_MOUNTED = 2
        const val STATE_MOUNTED_READ_ONLY = 3
        const val STATE_FORMATTING = 4
        const val STATE_EJECTING = 5
        const val STATE_UNMOUNTABLE = 6
        const val STATE_REMOVED = 7
        const val STATE_BAD_REMOVAL = 8
    }

    val isAvailable get() = type == TYPE_PUBLIC || type == TYPE_STUB || type == TYPE_EMULATED

    val id: String get() = clazz.getField("id").get(obj) as String
    val path: String? get() = clazz.getField("path").get(obj) as String?
    val type: Int get() = clazz.getField("type").get(obj) as Int
    val state: Int get() = clazz.getField("state").get(obj) as Int
    val isPrimary: Boolean get() = clazz.getMethod("isPrimary").invoke(obj) as Boolean
    val isEmulated: Boolean
        get() = when (type) {
            TYPE_EMULATED -> true
            TYPE_PUBLIC, TYPE_STUB -> false
            else -> throw IllegalStateException("Unexpected volume type $type")
        }
    val isRemovable: Boolean
        get() = when (type) {
            TYPE_EMULATED -> id != ID_EMULATED_INTERNAL && id != "$ID_EMULATED_INTERNAL;${context.userId}"
            TYPE_PUBLIC, TYPE_STUB -> true
            else -> throw IllegalStateException("Unexpected volume type $type")
        }

    override fun equals(other: Any?): Boolean {
        return clazz.getMethod("equals", Any::class.java).invoke(obj, other) as Boolean
    }

    override fun hashCode(): Int {
        return clazz.getMethod("hashCode").invoke(obj) as Int
    }
}

val Int.volumeStateArgs: VolumeState
    get() = when (this) {
        Volume.STATE_UNMOUNTED -> VolumeState.UNMOUNTED
        Volume.STATE_CHECKING -> VolumeState.CHECKING
        Volume.STATE_MOUNTED -> VolumeState.MOUNTED
        Volume.STATE_MOUNTED_READ_ONLY -> VolumeState.MOUNTED_READ_ONLY
        Volume.STATE_FORMATTING -> VolumeState.FORMATTING
        Volume.STATE_EJECTING -> VolumeState.EJECTING
        Volume.STATE_UNMOUNTABLE -> VolumeState.UNMOUNTABLE
        Volume.STATE_REMOVED -> VolumeState.REMOVED
        Volume.STATE_BAD_REMOVAL -> VolumeState.BAD_REMOVAL
        else -> VolumeState.UNKNOWN
    }