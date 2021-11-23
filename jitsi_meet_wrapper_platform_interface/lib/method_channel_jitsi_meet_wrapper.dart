import 'dart:async';

import 'package:flutter/services.dart';

import 'feature_flag.dart';
import 'jitsi_meet_wrapper_platform_interface.dart';
import 'jitsi_meeting_options.dart';
import 'jitsi_meeting_response.dart';

const MethodChannel _channel = MethodChannel('jitsi_meet');

/// An implementation of [JitsiMeetPlatform] that uses method channels.
class MethodChannelJitsiMeetWrapper extends JitsiMeetWrapperPlatformInterface {
  @override
  Future<JitsiMeetingResponse> joinMeeting(JitsiMeetingOptions options) async {
    Map<String, dynamic> _options = {
      'roomName': options.roomName.trim(),
      'serverUrl': options.serverUrl?.trim(),
      'subject': options.subject?.trim(),
      'token': options.token,
      'isAudioMuted': options.isAudioMuted,
      'isAudioOnly': options.isAudioOnly,
      'isVideoMuted': options.isVideoMuted,
      'userDisplayName': options.userDisplayName,
      'userEmail': options.userEmail,
      'userAvatarUrl': options.userAvatarUrl,
      'featureFlags': _toFeatureFlagStrings(options.featureFlags),
    };

    return await _channel
        .invokeMethod<String>('joinMeeting', _options)
        .then((message) => JitsiMeetingResponse(isSuccess: true, message: message))
        .catchError((error) => JitsiMeetingResponse(isSuccess: true, message: error.toString(), error: error));
  }

  Map<String, bool> _toFeatureFlagStrings(Map<FeatureFlag, bool> featureFlags) {
    Map<String, bool> featureFlagsWithStrings = {};
    featureFlags.forEach((key, value) => featureFlagsWithStrings[_toFeatureFlagString(key)] = value);
    return featureFlagsWithStrings;
  }

  String _toFeatureFlagString(FeatureFlag featureFlag) {
    // Constants from: https://github.com/jitsi/jitsi-meet/blob/master/react/features/base/flags/constants.js
    switch (featureFlag) {
      case FeatureFlag.isAddPeopleEnabled:
        return 'add-people.enabled';
      case FeatureFlag.isCalendarEnabled:
        return 'calendar.enabled';
      case FeatureFlag.isCallIntegrationEnabled:
        return 'call-integration.enabled';
      case FeatureFlag.isCloseCaptionsEnabled:
        return 'close-captions.enabled';
      case FeatureFlag.isChatEnabled:
        return 'chat.enabled';
      case FeatureFlag.isInviteEnabled:
        return 'invite.enabled';
      case FeatureFlag.isIosRecordingEnabled:
        return 'ios.recording.enabled';
      case FeatureFlag.isIosScreensharingEnabled:
        return 'ios.screensharing.enabled';
      case FeatureFlag.isLiveStreamingEnabled:
        return 'live-streaming.enabled';
      case FeatureFlag.isMeetingNameEnabled:
        return 'meeting-name.enabled';
      case FeatureFlag.isMeetingPasswordEnabled:
        return 'meeting-password.enabled';
      case FeatureFlag.isPipEnabled:
        return 'pip.enabled';
      case FeatureFlag.isRaiseHandEnabled:
        return 'raise-hand.enabled';
      case FeatureFlag.isRecordingEnabled:
        return 'recording.enabled';
      case FeatureFlag.isTitleViewEnabled:
        return 'tile-view.enabled';
      case FeatureFlag.isToolboxAlwaysVisible:
        return 'toolbox.alwaysVisible';
      case FeatureFlag.isWelcomePageEnabled:
        return 'welcomepage.enabled';
    }
  }
}
