package dev.hebei.storage

import android.content.Context
import android.os.storage.StorageManager

class StorageManagerApi(registrar: StoragePigeonProxyApiRegistrar, private val context: Context) :
    PigeonApiStorageManager(registrar) {
    private val clazz = StorageManager::class.java

    override fun getVolumes(pigeon_instance: StorageManager): List<Volume> {
        val volumes = clazz.getMethod("getVolumes").invoke(pigeon_instance) as List<*>
        return volumes.mapNotNull { obj ->
            if (obj == null) null
            else {
                val volume = Volume(obj, context)
                if (volume.isAvailable) volume
                else null
            }
        }
    }

    override fun registerListener(
        pigeon_instance: StorageManager, listener: StorageEventListener
    ) {
        val impl = listener as StorageEventListener.Impl
        val clazz = StorageManager::class.java
        val method = clazz.getMethod("registerListener", StorageEventListener.clazz)
        method.invoke(pigeon_instance, impl.listener)
    }

    override fun unregisterListener(pigeon_instance: StorageManager, listener: StorageEventListener) {
        val impl = listener as StorageEventListener.Impl
        val clazz = StorageManager::class.java
        val method = clazz.getMethod("unregisterListener", StorageEventListener.clazz)
        method.invoke(pigeon_instance, impl.listener)
    }
}