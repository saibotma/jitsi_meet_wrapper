import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'jitsi_meet_wrapper_platform_interface.dart';

const MethodChannel _methodChannel = MethodChannel('jitsi_meet_wrapper');
const EventChannel _eventChannel = EventChannel('jitsi_meet_wrapper_events');

/// An implementation of [JitsiMeetPlatform] that uses method channels.
class MethodChannelJitsiMeetWrapper extends JitsiMeetWrapperPlatformInterface {
  bool _eventChannelIsInitialized = false;
  JitsiMeetingListener? _listener;

  @override
  Future<JitsiMeetingResponse> joinMeeting({
    required JitsiMeetingOptions options,
    JitsiMeetingListener? listener,
  }) async {
    _listener = listener;
    if (!_eventChannelIsInitialized) {
      _initialize();
    }

    Map<String, dynamic> _options = {
      'roomName': options.roomNameOrUrl.trim(),
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
      'configOverrides': options.configOverrides,
    };

    return await _methodChannel
        .invokeMethod<String>('joinMeeting', _options)
        .then((message) {
      return JitsiMeetingResponse(isSuccess: true, message: message);
    }).catchError((error) {
      return JitsiMeetingResponse(
        isSuccess: true,
        message: error.toString(),
        error: error,
      );
    });
  }

  void _initialize() {
    _eventChannel.receiveBroadcastStream().listen((message) {
      final data = message['data'];
      switch (message['event']) {
        case "opened":
          _listener?.onOpened?.call();
          break;
        case "conferenceWillJoin":
          _listener?.onConferenceWillJoin?.call(data["url"]);
          break;
        case "conferenceJoined":
          _listener?.onConferenceJoined?.call(data["url"]);
          break;
        case "conferenceTerminated":
          _listener?.onConferenceTerminated?.call(data["url"], data["error"]);
          break;
        case "closed":
          _listener?.onClosed?.call();
          _listener = null;
          break;
      }
    }).onError((error) {
      debugPrint("Error receiving data from the event channel: $error");
    });
    _eventChannelIsInitialized = true;
  }

  Map<String, Object>? _toFeatureFlagStrings(
    Map<FeatureFlag, Object?>? featureFlags,
  ) {
    if (featureFlags == null) return null;
    Map<String, Object> featureFlagsWithStrings = {};
    featureFlags.forEach((key, value) {
      if (value != null) {
        featureFlagsWithStrings[_toFeatureFlagString(key)] = value;
      }
    });
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
      case FeatureFlag.isTileViewEnabled:
        return 'tile-view.enabled';
      case FeatureFlag.isToolboxAlwaysVisible:
        return 'toolbox.alwaysVisible';
      case FeatureFlag.isWelcomePageEnabled:
        return 'welcomepage.enabled';
      case FeatureFlag.isAudioFocusDisabled:
        return 'audio-focus.disabled';
      case FeatureFlag.isAudioMuteButtonEnabled:
        return 'audio-mute.enabled';
      case FeatureFlag.isAudioOnlyButtonEnabled:
        return 'audio-only.enabled';
      case FeatureFlag.isConferenceTimerEnabled:
        return 'conference-timer.enabled';
      case FeatureFlag.isFilmstripEnabled:
        return 'filmstrip.enabled';
      case FeatureFlag.isFullscreenEnabled:
        return 'fullscreen.enabled';
      case FeatureFlag.isHelpButtonEnabled:
        return 'help.enabled';
      case FeatureFlag.isAndroidScreensharingEnabled:
        return 'android.screensharing.enabled';
      case FeatureFlag.isKickoutEnabled:
        return 'kick-out.enabled';
      case FeatureFlag.isLobbyModeEnabled:
        return 'lobby-mode.enabled';
      case FeatureFlag.isNotificationsEnabled:
        return 'notifications.enabled';
      case FeatureFlag.isOverflowMenuEnabled:
        return 'overflow-menu.enabled';
      case FeatureFlag.isReactionsEnabled:
        return 'reactions.enabled';
      case FeatureFlag.isReplaceParticipantEnabled:
        return 'replace.participant';
      case FeatureFlag.resolution:
        return 'resolution';
      case FeatureFlag.areSecurityOptionsEnabled:
        return 'security-options.enabled';
      case FeatureFlag.isServerUrlChangeEnabled:
        return 'server-url-change.enabled';
      case FeatureFlag.isToolboxEnabled:
        return 'toolbox.alwaysVisible';
      case FeatureFlag.isVideoMuteButtonEnabled:
        return 'video-mute.enabled';
      case FeatureFlag.isVideoShareButtonEnabled:
        return 'video-share.enabled';
    }
  }
}
