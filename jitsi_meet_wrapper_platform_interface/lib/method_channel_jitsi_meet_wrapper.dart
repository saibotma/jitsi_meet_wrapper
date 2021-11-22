import 'dart:async';

import 'package:flutter/services.dart';

import 'feature_flag/feature_flag_enum.dart';
import 'feature_flag/feature_flag_helper.dart';
import 'jitsi_meet_wrapper_platform_interface.dart';
import 'jitsi_meeting_options.dart';
import 'jitsi_meeting_response.dart';

const MethodChannel _channel = MethodChannel('jitsi_meet');

/// An implementation of [JitsiMeetPlatform] that uses method channels.
class MethodChannelJitsiMeetWrapper extends JitsiMeetWrapperPlatformInterface {
  @override
  Future<JitsiMeetingResponse> joinMeeting(JitsiMeetingOptions options) async {
    Map<String, dynamic> _options = {
      'room': options.room.trim(),
      'serverURL': options.serverUrl?.trim(),
      'subject': options.subject,
      'token': options.token,
      'audioMuted': options.audioMuted,
      'audioOnly': options.audioOnly,
      'videoMuted': options.videoMuted,
      'featureFlags': _toFeatureFlagsWithStrings(options.featureFlags),
      'userDisplayName': options.userDisplayName,
      'userEmail': options.userEmail,
      'iosAppBarRGBAColor': options.iosAppBarRGBAColor,
    };

    return await _channel
        .invokeMethod<String>('joinMeeting', _options)
        .then((message) => JitsiMeetingResponse(isSuccess: true, message: message))
        .catchError(
      (error) {
        return JitsiMeetingResponse(isSuccess: true, message: error.toString(), error: error);
      },
    );
  }

  @override
  closeMeeting() {
    _channel.invokeMethod('closeMeeting');
  }

  Map<String?, bool> _toFeatureFlagsWithStrings(
    Map<FeatureFlagEnum, bool> featureFlags,
  ) {
    Map<String?, bool> featureFlagsWithStrings = const {};

    featureFlags.forEach((key, value) {
      featureFlagsWithStrings[FeatureFlagHelper.featureFlags[key]] = value;
    });

    return featureFlagsWithStrings;
  }
}
