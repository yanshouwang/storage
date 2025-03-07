package dev.hebei.storage

import android.content.Context


class StorageEventListenerApi(registrar: StoragePigeonProxyApiRegistrar, private val context: Context) :
    PigeonApiStorageEventListener(registrar) {
    override fun pigeon_defaultConstructor(): StorageEventListener {
        return StorageEventListener.Impl(this, context)
    }
}