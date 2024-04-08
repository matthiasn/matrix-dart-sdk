import 'package:matrix/matrix.dart';

extension AudioEventExtension on Event {
  /// returns if the event is a voice message
  bool get isVoiceMessage =>
      content['org.matrix.msc2516.voice'] != null ||
      content['org.matrix.msc3245.voice'] != null;
}

extension AudioEventRoomExtension on Room {
  /// Sends an audio file with appropriate info to this room. Returns the event
  /// ID generated by the server for this event.
  Future<String?> sendAudioEvent(
    MatrixAudioFile audioFile, {
    Event? replyTo,
    bool isVoiceMessage = false,
    int? durationInMs,
    List<int>? waveform,
    Map<String, dynamic>? otherFileInfo,
  }) {
    final extraContent = <String, Map<String, dynamic>>{};
    if (durationInMs != null) {
      otherFileInfo ??= {};
      otherFileInfo['duration'] = durationInMs;
    }
    if (otherFileInfo != null) extraContent['info'] = otherFileInfo;
    if (isVoiceMessage) {
      // No content, this is only used to identify if the event is a voice message.
      extraContent['org.matrix.msc3245.voice'] = {};
    }
    extraContent['org.matrix.msc1767.audio'] = {
      'duration': durationInMs,
      'waveform': waveform,
    };
    return sendFileEvent(
      audioFile,
      inReplyTo: replyTo,
      extraContent: extraContent,
    );
  }
}
