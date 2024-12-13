import 'media_action.dart';

final class MediaChangedEvent {
  final MediaAction action;
  final String? path;

  MediaChangedEvent({
    required this.action,
    required this.path,
  });
}
