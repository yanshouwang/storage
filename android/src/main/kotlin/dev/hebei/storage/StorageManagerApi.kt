package dev.hebei.storage

import android.os.Build
import android.os.storage.StorageManager
import java.util.concurrent.Executor

class StorageManagerApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiStorageManager(registrar) {
    override fun getStorageVolumes(pigeon_instance: StorageManager): List<StorageVolume> {
        return pigeon_instance.storageVolumes.map { StorageVolume(it) }
    }

    override fun registerStorageVolumeCallback(
        pigeon_instance: StorageManager, executor: Executor, callback: StorageVolumeCallback
    ) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val impl = callback as StorageVolumeCallbackApi.Impl30
            pigeon_instance.registerStorageVolumeCallback(executor, impl.callback)
        } else {
            val impl = callback as StorageVolumeCallbackApi.Impl
            impl.executor = executor
            val clazz = StorageManager::class.java
            val method = clazz.getMethod("registerListener", impl.clazz)
            method.invoke(pigeon_instance, impl.listener)
        }
    }

    override fun unregisterStorageVolumeCallback(pigeon_instance: StorageManager, callback: StorageVolumeCallback) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val impl = callback as StorageVolumeCallbackApi.Impl30
            pigeon_instance.unregisterStorageVolumeCallback(impl.callback)
        } else {
            val impl = callback as StorageVolumeCallbackApi.Impl
            val clazz = StorageManager::class.java
            val method = clazz.getMethod("unregisterListener", impl.clazz)
            method.invoke(pigeon_instance, impl.listener)
        }
    }
}