package dev.hebei.storage

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** StoragePlugin */
class StoragePlugin : FlutterPlugin {
    private lateinit var _applicationContext: Context
    private lateinit var _registrar: StoragePigeonProxyApiRegistrar

    val applicationContext: Context get() = _applicationContext

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        _applicationContext = binding.applicationContext
        _registrar = StorageRegistrar(binding.binaryMessenger, this)
        _registrar.setUp()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        _registrar.tearDown()
        _registrar.instanceManager.stopFinalizationListener()
    }
}
