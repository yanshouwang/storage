package dev.hebei.storage

import android.annotation.SuppressLint
import android.content.Context
import net.bytebuddy.ByteBuddy
import net.bytebuddy.android.AndroidClassLoadingStrategy.Wrapping
import net.bytebuddy.implementation.InvocationHandlerAdapter
import net.bytebuddy.matcher.ElementMatchers
import java.lang.reflect.InvocationHandler

interface StorageEventListener {
    companion object {
        @SuppressLint("PrivateApi")
        val clazz: Class<*> = Class.forName("android.os.storage.StorageEventListener")
    }

    fun onVolumeStateChanged(volume: Volume, oldState: Int, newState: Int)

    class Impl(private val api: StorageEventListenerApi, private val context: Context) : StorageEventListener {
        private val handler = InvocationHandler { _, _, args ->
            val vol = args[0]
            val oldState = args[1] as Int
            val newState = args[2] as Int
            val volume = Volume(vol, context)
            if (volume.isAvailable) this@Impl.onVolumeStateChanged(volume, oldState, newState)
        }
        private val dir = context.getDir("generated", Context.MODE_PRIVATE)
        private val strategy = Wrapping(dir)

        val listener: Any = ByteBuddy().subclass(clazz).method(ElementMatchers.named("onVolumeStateChanged"))
            .intercept(InvocationHandlerAdapter.of(handler)).make()
            .load(clazz.classLoader, strategy).loaded.getConstructor().newInstance()

        override fun onVolumeStateChanged(volume: Volume, oldState: Int, newState: Int) {
            api.onVolumeStateChanged(this, volume, oldState.volumeStateArgs, newState.volumeStateArgs) {}
        }
    }
}