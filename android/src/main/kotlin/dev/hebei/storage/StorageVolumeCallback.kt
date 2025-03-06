package dev.hebei.storage

interface StorageVolumeCallback {
    fun onStateChanged(volume: StorageVolume)
}