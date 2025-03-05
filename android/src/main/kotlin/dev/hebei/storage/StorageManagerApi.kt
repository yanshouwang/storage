package dev.hebei.storage

import android.os.Build
import android.os.storage.StorageManager
import android.os.storage.StorageVolume
import androidx.annotation.RequiresApi
import java.util.concurrent.Executor

class StorageManagerApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiStorageManager(registrar) {
    override fun getStorageVolumes(pigeon_instance: StorageManager): List<StorageVolume> {
        return pigeon_instance.storageVolumes
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun registerStorageVolumeCallback(
        pigeon_instance: StorageManager, executor: Executor, callback: StorageManager.StorageVolumeCallback
    ) {
        pigeon_instance.registerStorageVolumeCallback(executor, callback)
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun unregisterStorageVolumeCallback(
        pigeon_instance: StorageManager, callback: StorageManager.StorageVolumeCallback
    ) {
        pigeon_instance.unregisterStorageVolumeCallback(callback)
    }
}