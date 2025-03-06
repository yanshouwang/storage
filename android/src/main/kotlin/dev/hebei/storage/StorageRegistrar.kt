package dev.hebei.storage

import io.flutter.plugin.common.BinaryMessenger

class StorageRegistrar(binaryMessenger: BinaryMessenger, private val storagePlugin: StoragePlugin) :
    StoragePigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiStoragePlugin(): PigeonApiStoragePlugin {
        return StoragePluginApi(this, storagePlugin)
    }

    override fun getPigeonApiContextCompat(): PigeonApiContextCompat {
        return ContextCompatApi(this)
    }

    override fun getPigeonApiStorageManager(): PigeonApiStorageManager {
        return StorageManagerApi(this)
    }

    override fun getPigeonApiStorageVolume(): PigeonApiStorageVolume {
        return StorageVolumeApi(this)
    }

    override fun getPigeonApiStorageVolumeCallback(): PigeonApiStorageVolumeCallback {
        return StorageVolumeCallbackApi(this, storagePlugin.applicationContext)
    }
}