package dev.hebei.storage

import android.content.Context


class StorageVolumeCallbackApi(registrar: StoragePigeonProxyApiRegistrar, private val context: Context) :
    PigeonApiStorageVolumeCallback(registrar) {
    override fun pigeon_defaultConstructor(): StorageVolumeCallback {
        return StorageVolumeCallback.Impl(this, context)
    }
}