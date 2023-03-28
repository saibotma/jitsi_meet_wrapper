import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet_wrapper_platform_interface/jitsi_meet_wrapper_platform_interface.dart';

class JitsiMeetViewController {
  JitsiMeetViewController({
    required int id,
    JitsiMeetingListener? listener,
  })  : _channel = MethodChannel(
            'plugins.jitsi_meet_wrapper/jitsi_meet_native_view_$id'),
        _listener = listener;

  final MethodChannel _channel;
  final EventChannel _eventChannel =
      const EventChannel('plugins.jitsi_meet_wrapper:jitsi_meet_native_view');
  JitsiMeetingListener? _listener;

  Future<void> join() async {
    await _channel.invokeMethod('join');
  }

  Future<void> hangUp() async {
    await _channel.invokeMethod('hangUp');
  }

  Future<void> setAudioMuted(bool isMuted) async {
    await _channel.invokeMethod('setAudioMuted', {"isMuted": isMuted});
  }

  Future<void> attachListener(JitsiMeetingListener listener) async {
    await JitsiMeetWrapperPlatformInterface.instance.attachListener(listener);
  }
}
