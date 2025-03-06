package dev.hebei.storage

import io.flutter.plugin.common.BinaryMessenger

class StorageRegistrar(binaryMessenger: BinaryMessenger, private val instance: StoragePlugin) :
    StoragePigeonProxyApiRegistrar(binaryMessenger) {
    override fun getPigeonApiStoragePlugin(): PigeonApiStoragePlugin {
        return StoragePluginApi(this, instance)
    }

    override fun getPigeonApiContextCompat(): PigeonApiContextCompat {
        return ContextCompatApi(this)
    }

    override fun getPigeonApiStorageManager(): PigeonApiStorageManager {
        return StorageManagerApi(this, instance.context)
    }

    override fun getPigeonApiStorageVolume(): PigeonApiStorageVolume {
        return StorageVolumeApi(this)
    }

    override fun getPigeonApiStorageVolumeCallback(): PigeonApiStorageVolumeCallback {
        return StorageVolumeCallbackApi(this, instance.context)
    }
}