/// Enumeration of all available feature flags
/// Reflects the official list of Jitsi Meet SDK 2.9.0 feature flags
/// https://github.com/jitsi/jitsi-meet/blob/master/react/features/base/flags/constants.js
enum FeatureFlag {
  /// Flag indicating if add-people functionality should be enabled.
  /// Default: enabled (true).
  isAddPeopleEnabled,

  /// Flag indicating if calendar integration should be enabled.
  /// Default: enabled (true) on Android, auto-detected on iOS.
  isCalendarEnabled,

  /// Flag indicating if call integration (CallKit on iOS, 
  /// ConnectionService on Android)
  /// should be enabled.
  /// Default: enabled (true).
  isCallIntegrationEnabled,

  /// Flag indicating if close captions should be enabled.
  /// Default: enabled (true).
  isCloseCaptionsEnabled,

  /// Flag indicating if chat should be enabled.
  /// Default: enabled (true).
  isChatEnabled,

  /// Flag indicating if invite functionality should be enabled.
  /// Default: enabled (true).
  isInviteEnabled,

  /// Flag indicating if recording should be enabled in iOS.
  /// Default: disabled (false).
  isIosRecordingEnabled,

  /// Flag indicating if screen sharing should be enabled in iOS.
  /// Default: disabled (false).
  isIosScreensharingEnabled,

  /// Flag indicating if live-streaming should be enabled.
  /// Default: auto-detected.
  isLiveStreamingEnabled,

  /// Flag indicating if displaying the meeting name should be enabled.
  /// Default: enabled (true).
  isMeetingNameEnabled,

  /// Flag indicating if the meeting password button should be enabled. Note 
  /// that this flag just decides on the buttton, if a meeting has a password
  /// set, the password ddialog will still show up.
  /// Default: enabled (true).
  isMeetingPasswordEnabled,

  /// Flag indicating if Picture-in-Picture should be enabled.
  /// Default: auto-detected.
  isPipEnabled,

  /// Flag indicating if raise hand feature should be enabled.
  /// Default: enabled.
  isRaiseHandEnabled,

  /// Flag indicating if recording should be enabled.
  /// Default: auto-detected.
  isRecordingEnabled,

  /// Flag indicating if tile view feature should be enabled.
  /// Default: enabled.
  isTitleViewEnabled,

  /// Flag indicating if the toolbox should be always be visible
  /// Default: disabled (false).
  isToolboxAlwaysVisible,

  /// Flag indicating if the welcome page should be enabled.
  /// Default: disabled (false).
  isWelcomePageEnabled,
}
