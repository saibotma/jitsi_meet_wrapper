import 'feature_flag_enum.dart';

/// Helper containing the associative map with feature flags and their string values.
/// Reflects the official list of Jitsi Meet SDK 2.9.0 feature flags
/// https://github.com/jitsi/jitsi-meet/blob/master/react/features/base/flags/constants.js
class FeatureFlagHelper {
  static Map<FeatureFlagEnum, String> featureFlags = {
    FeatureFlagEnum.isAddPeopleEnabled: 'add-people.enabled',
    FeatureFlagEnum.isCalendarEnabled: 'calendar.enabled',
    FeatureFlagEnum.isCallIntegrationEnabled: 'call-integration.enabled',
    FeatureFlagEnum.isCloseCaptionsEnabled: 'close-captions.enabled',
    FeatureFlagEnum.isChatEnabled: 'chat.enabled',
    FeatureFlagEnum.isInviteEnabled: 'invite.enabled',
    FeatureFlagEnum.isIosRecordingEnabled: 'ios.recording.enabled',
    FeatureFlagEnum.isLiveStreamingEnabled: 'live-streaming.enabled',
    FeatureFlagEnum.isMeetingNameEnabled: 'meeting-name.enabled',
    FeatureFlagEnum.isMeetingPasswordEnabled: 'meeting-password.enabled',
    FeatureFlagEnum.isPipEnabled: 'pip.enabled',
    FeatureFlagEnum.isRaiseHandEnabled: 'raise-hand.enabled',
    FeatureFlagEnum.isRecordingEnabled: 'recording.enabled',
    FeatureFlagEnum.isTitleViewEnabled: 'tile-view.enabled',
    FeatureFlagEnum.isToolboxAlwaysVisible: 'toolbox.alwaysVisible',
    FeatureFlagEnum.isWelcomePageEnabled: 'welcomepage.enabled',
  };
}
