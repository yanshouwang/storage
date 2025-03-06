// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/storage.g.dart',
    kotlinOut: 'android/src/main/kotlin/dev/hebei/storage/Storage.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'dev.hebei.storage',
      errorClassName: 'StorageError',
    ),
  ),
)
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.storage.StoragePlugin',
  ),
)
abstract class StoragePlugin {
  @static
  late final StoragePlugin instance;
  @attached
  late final Context applicationContext;
}

/// Interface to global information about an application environment. This is an
/// abstract class whose implementation is provided by the Android system. It
/// allows access to application-specific resources and classes, as well as up-calls
/// for application-level operations such as launching activities, broadcasting
/// and receiving intents, etc.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.content.Context',
  ),
)
abstract class Context {}

/// Helper for accessing features in Context.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'androidx.core.content.ContextCompat',
  ),
)
abstract class ContextCompat {
  /// Return an Executor that will run enqueued tasks on the main thread associated
  /// with this context. This is the thread used to dispatch calls to application
  /// components (activities, services, etc).
  @static
  Executor getMainExecutor(Context context);

  /// Return the handle to a system-level service by class.
  @static
  StorageManager? getStorageManager(Context context);
}

/// An object that executes submitted Runnable tasks. This interface provides a
/// way of decoupling task submission from the mechanics of how each task will be
/// run, including details of thread use, scheduling, etc. An Executor is normally
/// used instead of explicitly creating threads. For example, rather than invoking
/// new Thread(new RunnableTask()).start() for each of a set of tasks, you might
/// use:
///
/// ``` Kotlin
/// <code>Executor executor = anExecutor();
///  executor.execute(new RunnableTask1());
///  executor.execute(new RunnableTask2());
///  ...</code>
/// ```
///
/// However, the Executor interface does not strictly require that execution be
/// asynchronous. In the simplest case, an executor can run the submitted task
/// immediately in the caller's thread:
///
/// ``` Kotlin
/// <code>class DirectExecutor implements Executor {
///    public void execute(Runnable r) {
///      r.run();
///    }
///  }</code>
/// ```
///
/// More typically, tasks are executed in some thread other than the caller's
/// thread. The executor below spawns a new thread for each task.
///
/// ``` Kotlin
/// <code>class ThreadPerTaskExecutor implements Executor {
///    public void execute(Runnable r) {
///      new Thread(r).start();
///    }
///  }</code>
/// ```
///
/// Many Executor implementations impose some sort of limitation on how and when
/// tasks are scheduled. The executor below serializes the submission of tasks to
/// a second executor, illustrating a composite executor.
///
/// ``` Kotlin
/// <code>class SerialExecutor implements Executor {
///    final Queue&lt;Runnable&gt; tasks = new ArrayDeque&lt;&gt;();
///    final Executor executor;
///    Runnable active;
///
///    SerialExecutor(Executor executor) {
///      this.executor = executor;
///    }
///
///    public synchronized void execute(Runnable r) {
///      tasks.add(() -&gt; {
///        try {
///          r.run();
///        } finally {
///          scheduleNext();
///        }
///      });
///      if (active == null) {
///        scheduleNext();
///      }
///    }
///
///    protected synchronized void scheduleNext() {
///      if ((active = tasks.poll()) != null) {
///        executor.execute(active);
///      }
///    }
///  }</code>
/// ```
///
/// The Executor implementations provided in this package implement ExecutorService,
/// which is a more extensive interface. The ThreadPoolExecutor class provides an
/// extensible thread pool implementation. The Executors class provides convenient
/// factory methods for these Executors.
///
/// Memory consistency effects: Actions in a thread prior to submitting a Runnable
/// object to an Executor happen-before its execution begins, perhaps in another
/// thread.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'java.util.concurrent.Executor',
  ),
)
abstract class Executor {}

/// StorageManager is the interface to the systems storage service. The storage
/// manager handles storage-related items such as Opaque Binary Blobs (OBBs).
///
/// OBBs contain a filesystem that maybe be encrypted on disk and mounted on-demand
/// from an application. OBBs are a good way of providing large amounts of binary
/// assets without packaging them into APKs as they may be multiple gigabytes in
/// size. However, due to their size, they're most likely stored in a shared
/// storage pool accessible from all programs. The system does not guarantee the
/// security of the OBB file itself: if any program modifies the OBB, there is no
/// guarantee that a read from that OBB will produce the expected output.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'android.os.storage.StorageManager',
  ),
)
abstract class StorageManager {
  /// Return the list of shared/external storage volumes currently available to
  /// the calling user.
  ///
  /// These storage volumes are actively attached to the device, but may be in
  /// any mount state, as returned by StorageVolume.getState(). Returns both the
  /// primary shared storage device and any attached external volumes, including
  /// SD cards and USB drives.
  List<StorageVolume> getStorageVolumes();

  /// Registers the given callback to listen for StorageVolume changes.
  ///
  /// For example, this can be used to detect when a volume changes to the
  /// Environment.MEDIA_MOUNTED or Environment.MEDIA_UNMOUNTED states.
  void registerStorageVolumeCallback(
      Executor executor, StorageVolumeCallback callback);

  /// Unregisters the given callback from listening for StorageVolume changes.
  void unregisterStorageVolumeCallback(StorageVolumeCallback callback);
}

/// Information about a shared/external storage volume for a specific user.
///
/// A device always has one (and one only) primary storage volume, but it could
/// have extra volumes, like SD cards and USB drives. This object represents the
/// logical view of a storage volume for a specific user: different users might
/// have different views for the same physical volume (for example, if the volume
/// is a built-in emulated storage).
///
/// The storage volume is not necessarily mounted, applications should use getState()
/// to verify its state.
///
/// Applications willing to read or write to this storage volume needs to get a
/// permission from the user first, which can be achieved in the following ways:
///
/// * To get access to standard directories (like the Environment.DIRECTORY_PICTURES),
/// they can use the createAccessIntent(java.lang.String). This is the recommend
/// way, since it provides a simpler API and narrows the access to the given
/// directory (and its descendants).
/// * To get access to any directory (and its descendants), they can use the
/// Storage Access Framework APIs (such as Intent.ACTION_OPEN_DOCUMENT and
/// Intent.ACTION_OPEN_DOCUMENT_TREE, although these APIs do not guarantee the
/// user will select this specific volume.
/// * To get read and write access to the primary storage volume, applications
/// can declare the android.Manifest.permission#READ_EXTERNAL_STORAGE and
/// android.Manifest.permission#WRITE_EXTERNAL_STORAGE permissions respectively,
/// with the latter including the former. This approach is discouraged, since
/// users may be hesitant to grant broad access to all files contained on a storage
/// device.
///
/// It can be obtained through StorageManager.getStorageVolumes() and
/// StorageManager.getPrimaryStorageVolume() and also as an extra in some broadcasts
/// (see EXTRA_STORAGE_VOLUME).
///
/// See Environment.getExternalStorageDirectory() for more info about shared/external
/// storage semantics.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.storage.StorageVolume',
  ),
)
abstract class StorageVolume {
  /// Returns the directory where this volume is currently mounted.
  ///
  /// Direct filesystem access via this path has significant emulation overhead,
  /// and apps are instead strongly encouraged to interact with media on storage
  /// volumes via the MediaStore APIs.
  ///
  /// This directory does not give apps any additional access beyond what they
  /// already have via MediaStore.
  String? getPath();

  /// Returns the current state of the volume.
  MediaState getState();

  /// Returns true if the volume is emulated.
  bool isEmulated();

  /// Returns true if the volume is the primary shared/external storage, which is
  /// the volume backed by Environment.getExternalStorageDirectory().
  bool isPrimary();

  /// Returns true if the volume is removable.
  bool isRemovable();
}

/// Callback that delivers StorageVolume related events.
///
/// For example, this can be used to detect when a volume changes to the
/// Environment.MEDIA_MOUNTED or Environment.MEDIA_UNMOUNTED states.
@ProxyApi(
  kotlinOptions: KotlinProxyApiOptions(
    fullClassName: 'dev.hebei.storage.StorageVolumeCallback',
  ),
)
abstract class StorageVolumeCallback {
  StorageVolumeCallback();

  /// Called when StorageVolume.getState() changes, such as changing to the
  /// Environment.MEDIA_MOUNTED or Environment.MEDIA_UNMOUNTED states.
  ///
  /// The given argument is a snapshot in time and can be used to process events
  /// in the order they occurred, or you can call StorageManager.getStorageVolumes()
  /// to observe the latest value.
  late final void Function(StorageVolume volume) onStateChanged;
}

enum MediaState {
  /// Unknown storage state, such as when a path isn't backed by known storage
  /// media.
  unknown,

  /// Storage state if the media is not present.
  removed,

  /// Storage state if the media is present but not mounted.
  unmounted,

  /// Storage state if the media is present and being disk-checked.
  checking,

  /// Storage state if the media is present but is blank or is using an unsupported
  /// filesystem.
  nofs,

  /// Storage state if the media is present and mounted at its mount point with
  /// read/write access.
  mounted,

  /// Storage state if the media is present and mounted at its mount point with
  /// read-only access.
  mountedReadOnly,

  /// Storage state if the media is present not mounted, and shared via USB mass
  /// storage.
  shared,

  /// Storage state if the media was removed before it was unmounted.
  badRemoval,

  /// Storage state if the media is present but cannot be mounted. Typically this
  /// happens if the file system on the media is corrupted.
  unmountable,

  /// Storage state if the media is in the process of being ejected.
  ejecting,
}
