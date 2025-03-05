package dev.hebei.storage

import android.content.Context
import android.os.storage.StorageManager
import androidx.core.content.ContextCompat

class ContextCompatApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiContextCompat(registrar) {
    override fun getStorageManager(context: Context): StorageManager? {
        return ContextCompat.getSystemService(context, StorageManager::class.java)
    }
}