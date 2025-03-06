package dev.hebei.storage

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.os.UserHandle
import android.os.storage.StorageManager
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import net.bytebuddy.ByteBuddy
import net.bytebuddy.android.AndroidClassLoadingStrategy.Wrapping
import net.bytebuddy.implementation.InvocationHandlerAdapter
import net.bytebuddy.matcher.ElementMatchers
import java.lang.reflect.InvocationHandler
import java.util.concurrent.Executor


class StorageVolumeCallbackApi(registrar: StoragePigeonProxyApiRegistrar, private val context: Context) :
    PigeonApiStorageVolumeCallback(registrar) {
    override fun pigeon_defaultConstructor(): StorageVolumeCallback {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) Impl30(this)
        else Impl(this)
    }

    @RequiresApi(Build.VERSION_CODES.R)
    class Impl30(private val api: StorageVolumeCallbackApi) : StorageVolumeCallback {
        val callback = object : StorageManager.StorageVolumeCallback() {
            override fun onStateChanged(volume: android.os.storage.StorageVolume) {
                super.onStateChanged(volume)
                val volumeArgs = StorageVolume(volume)
                this@Impl30.onStateChanged(volumeArgs)
            }
        }

        override fun onStateChanged(volume: StorageVolume) {
            Log.d("storage", "onStateChanged: ${volume.hashCode()}, ${volume.path}, ${volume.state}")
            api.onStateChanged(this, volume) {}
        }
    }

    class Impl(private val api: StorageVolumeCallbackApi) : StorageVolumeCallback {
        private val storageManager = ContextCompat.getSystemService(api.context, StorageManager::class.java)
            ?: throw UnsupportedOperationException()

        @SuppressLint("PrivateApi")
        val clazz: Class<*> = Class.forName("android.os.storage.StorageEventListener")

        @SuppressLint("PrivateApi")
        private val volClazz = Class.forName("android.os.storage.VolumeInfo")
        private val getPathForUserMethod = volClazz.getMethod("getPathForUser", Int::class.java)
        private val buildStorageVolumeMethod =
            volClazz.getMethod("buildStorageVolume", Context::class.java, Int::class.java, Boolean::class.java)

        private val myUserIdMethod = UserHandle::class.java.getMethod("myUserId")

        private val handler = InvocationHandler { _, _, args ->
            val vol = args[0]
            val id = myUserIdMethod.invoke(null)
            val volume =
                buildStorageVolumeMethod.invoke(vol, api.context, id, false) as android.os.storage.StorageVolume
            val volumeArgs = StorageVolume(volume)
            Log.d("storage", "onVolumeStateChanged: ${volumeArgs.hashCode()}, ${volumeArgs.path}, ${volumeArgs.state}")
            this@Impl.onStateChanged(volumeArgs)
        }
        private val dir = api.context.getDir("generated", Context.MODE_PRIVATE)
        private val strategy = Wrapping(dir)

        val listener: Any = ByteBuddy().subclass(clazz).method(ElementMatchers.named("onVolumeStateChanged"))
            .intercept(InvocationHandlerAdapter.of(handler)).make()
            .load(clazz.classLoader, strategy).loaded.getConstructor().newInstance()

        lateinit var executor: Executor

        override fun onStateChanged(volume: StorageVolume) {
            executor.execute {
                api.onStateChanged(this, volume) {}
            }
        }
    }
}