package dev.hebei.storage

import android.content.Context
import android.os.storage.StorageManager
import java.util.concurrent.Executor

class StorageManagerApi(registrar: StoragePigeonProxyApiRegistrar, private val context: Context) :
    PigeonApiStorageManager(registrar) {
    private val clazz = StorageManager::class.java

    override fun getStorageVolumes(pigeon_instance: StorageManager): List<StorageVolume> {
        val volumes = clazz.getMethod("getVolumes").invoke(pigeon_instance) as List<*>
        return volumes.mapNotNull { obj ->
            if (obj == null) null
            else {
                val volume = StorageVolume(obj, context)
                if (volume.isAvailable) volume
                else null
            }
        }
    }

    override fun registerStorageVolumeCallback(
        pigeon_instance: StorageManager, executor: Executor, callback: StorageVolumeCallback
    ) {
        val impl = callback as StorageVolumeCallback.Impl
        impl.executor = executor
        val clazz = StorageManager::class.java
        val method = clazz.getMethod("registerListener", StorageVolumeCallback.clazz)
        method.invoke(pigeon_instance, impl.listener)
    }

    override fun unregisterStorageVolumeCallback(pigeon_instance: StorageManager, callback: StorageVolumeCallback) {
        val impl = callback as StorageVolumeCallback.Impl
        val clazz = StorageManager::class.java
        val method = clazz.getMethod("unregisterListener", StorageVolumeCallback.clazz)
        method.invoke(pigeon_instance, impl.listener)
    }
}