package dev.hebei.storage

import android.os.Build
import android.os.storage.StorageManager
import android.os.storage.StorageVolume
import androidx.annotation.RequiresApi

class StorageVolumeCallbackApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiStorageVolumeCallback(registrar) {
    @RequiresApi(Build.VERSION_CODES.R)
    override fun pigeon_defaultConstructor(): StorageManager.StorageVolumeCallback {
        return object : StorageManager.StorageVolumeCallback() {
            override fun onStateChanged(volume: StorageVolume) {
                super.onStateChanged(volume)
                this@StorageVolumeCallbackApi.onStateChanged(this, volume) {}
            }
        }
    }
}