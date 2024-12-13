enum MediaAction {
  /// Broadcast Action: External media was removed from SD card slot, but mount
  /// point was not unmounted. The path to the mount point for the removed media
  /// is contained in the Intent.mData field.
  badRemoval,

  /// Broadcast Action: The "Media Button" was pressed. Includes a single extra
  /// field, EXTRA_KEY_EVENT, containing the key event that caused the broadcast.
  button,

  /// Broadcast Action: External media is present, and being disk-checked The path
  /// to the mount point for the checking media is contained in the Intent.mData
  /// field.
  checking,

  /// Broadcast Action: User has expressed the desire to remove the external
  /// storage media. Applications should close all files they have open within
  /// the mount point when they receive this intent. The path to the mount point
  /// for the media to be ejected is contained in the Intent.mData field.
  eject,

  /// Broadcast Action: External media is present and mounted at its mount point.
  /// The path to the mount point for the mounted media is contained in the
  /// Intent.mData field. The Intent contains an extra with name "read-only" and
  /// Boolean value to indicate if the media was mounted read only.
  mounted,

  /// Broadcast Action: External media is present, but is using an incompatible
  /// fs (or is blank) The path to the mount point for the checking media is
  /// contained in the Intent.mData field.
  nofs,

  /// Broadcast Action: External media has been removed. The path to the mount
  /// point for the removed media is contained in the Intent.mData field.
  removed,

  /// Broadcast Action: The media scanner has finished scanning a directory. The
  /// path to the scanned directory is contained in the Intent.mData field.
  scannerFinished,

  /// Broadcast Action: Request the media scanner to scan a file and add it to
  /// the media database.
  ///
  /// The path to the file is contained in Intent#getData().
  scannerScanFile,

  /// Broadcast Action: The media scanner has started scanning a directory. The
  /// path to the directory being scanned is contained in the Intent.mData field.
  scannerStarted,

  /// Broadcast Action: External media is unmounted because it is being shared
  /// via USB mass storage. The path to the mount point for the shared media is
  /// contained in the Intent.mData field.
  shared,

  /// Broadcast Action: External media is present but cannot be mounted. The path
  /// to the mount point for the unmountable media is contained in the Intent.mData
  /// field.
  unmountable,

  /// Broadcast Action: External media is present, but not mounted at its mount
  /// point. The path to the mount point for the unmounted media is contained in
  /// the Intent.mData field.
  unmounted,
}
