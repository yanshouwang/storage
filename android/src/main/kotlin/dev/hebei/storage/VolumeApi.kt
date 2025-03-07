package dev.hebei.storage

class VolumeApi(registrar: StoragePigeonProxyApiRegistrar) : PigeonApiVolume(registrar) {
    override fun getId(pigeon_instance: Volume): String {
        return pigeon_instance.id
    }

    override fun getPath(pigeon_instance: Volume): String? {
        return pigeon_instance.path
    }

    override fun getState(pigeon_instance: Volume): VolumeState {
        return pigeon_instance.state.volumeStateArgs
    }

    override fun isEmulated(pigeon_instance: Volume): Boolean {
        return pigeon_instance.isEmulated
    }

    override fun isPrimary(pigeon_instance: Volume): Boolean {
        return pigeon_instance.isPrimary
    }

    override fun isRemovable(pigeon_instance: Volume): Boolean {
        return pigeon_instance.isRemovable
    }
}
