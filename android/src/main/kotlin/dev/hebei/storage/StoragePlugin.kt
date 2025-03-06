package dev.hebei.storage

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** StoragePlugin */
class StoragePlugin : FlutterPlugin {
    private lateinit var applicationContext: Context
    private lateinit var registrar: StoragePigeonProxyApiRegistrar

    val context: Context get() = applicationContext

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        registrar = StorageRegistrar(binding.binaryMessenger, this)
        registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        registrar.tearDown()
        registrar.instanceManager.stopFinalizationListener()
    }
}

