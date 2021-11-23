import 'dart:async';

import 'package:jitsi_meet_wrapper_platform_interface/jitsi_meet_wrapper_platform_interface.dart';
import 'package:jitsi_meet_wrapper_platform_interface/jitsi_meeting_options.dart';
import 'package:jitsi_meet_wrapper_platform_interface/jitsi_meeting_response.dart';

export 'package:jitsi_meet_wrapper_platform_interface/jitsi_meet_wrapper_platform_interface.dart'
    show JitsiMeetingOptions, JitsiMeetingResponse, FeatureFlag;

class JitsiMeetWrapper {
  /// Joins a meeting based on the JitsiMeetingOptions passed in.
  /// A JitsiMeetingListener can be attached to this meeting that will automatically
  /// be removed when the meeting has ended
  static Future<JitsiMeetingResponse> joinMeeting(JitsiMeetingOptions options) async {
    assert(options.roomName.trim().isNotEmpty, "room is empty");

    if (options.serverUrl?.isNotEmpty ?? false) {
      assert(Uri.parse(options.serverUrl!).isAbsolute,
          "URL must be of the format <scheme>://<host>[/path], like https://someHost.com");
    }

    return await JitsiMeetWrapperPlatformInterface.instance.joinMeeting(options);
  }

  static closeMeeting() => JitsiMeetWrapperPlatformInterface.instance.closeMeeting();
}