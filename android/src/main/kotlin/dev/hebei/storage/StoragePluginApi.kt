package dev.hebei.storage

import android.content.Context

class StoragePluginApi(registrar: StoragePigeonProxyApiRegistrar, private val instance: StoragePlugin) :
    PigeonApiStoragePlugin(registrar) {
    override fun instance(): StoragePlugin {
        return instance
    }

    override fun applicationContext(pigeon_instance: StoragePlugin): Context {
        return pigeon_instance.context
    }
}