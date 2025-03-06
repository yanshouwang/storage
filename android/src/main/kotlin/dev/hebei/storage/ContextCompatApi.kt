package dev.hebei.storage

import android.content.Context
import android.os.storage.StorageManager
import androidx.core.content.ContextCompat
import java.util.concurrent.Executor

class ContextCompatApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiContextCompat(registrar) {
    override fun getMainExecutor(context: Context): Executor {
        return ContextCompat.getMainExecutor(context)
    }

    override fun getStorageManager(context: Context): StorageManager? {
        return ContextCompat.getSystemService(context, StorageManager::class.java)
    }
}