package dev.hebei.storage

import android.content.Context
import java.util.concurrent.Executor

class ContextApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiContext(registrar) {
    override fun getMainExecutor(pigeon_instance: Context): Executor {
        return pigeon_instance.mainExecutor
    }
}