package dev.hebei.storage

import android.annotation.SuppressLint
import android.content.Context
import net.bytebuddy.ByteBuddy
import net.bytebuddy.android.AndroidClassLoadingStrategy.Wrapping
import net.bytebuddy.implementation.InvocationHandlerAdapter
import net.bytebuddy.matcher.ElementMatchers
import java.lang.reflect.InvocationHandler
import java.util.concurrent.Executor

interface StorageVolumeCallback {
    companion object {
        @SuppressLint("PrivateApi")
        val clazz: Class<*> = Class.forName("android.os.storage.StorageEventListener")
    }

    fun onStateChanged(volume: StorageVolume)

    class Impl(private val api: StorageVolumeCallbackApi, private val context: Context) : StorageVolumeCallback {
        private val handler = InvocationHandler { _, _, args ->
            val obj = args[0]
            val volume = StorageVolume(obj, context)
            if (volume.isAvailable) this@Impl.onStateChanged(volume)
        }
        private val dir = context.getDir("generated", Context.MODE_PRIVATE)
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