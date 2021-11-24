/// Enumeration of all available feature flags
///
/// Reflects the official list of Jitsi Meet SDK feature flags.
/// https://github.com/jitsi/jitsi-meet/blob/a618697e34d947f0cc0d9ee4a0fc79c76fbae5e6/react/features/base/flags/constants.js
enum FeatureFlag {
  /// Flag indicating if add-people functionality should be enabled.
  /// Default: enabled (true).
  isAddPeopleEnabled,

  /// Flag indicating if the SDK should not require the audio focus.
  /// Used by apps that do not use Jitsi audio.
  /// Default: disabled (false).
  isAudioFocusDisabled,

  /// Flag indicating if the audio mute button should be displayed.
  /// Default: enabled (true).
  isAudioMuteButtonEnabled,

  /// Flag indicating that the Audio only button in the overflow menu is enabled.
  /// Default: enabled (true).
  isAudioOnlyButtonEnabled,

  /// Flag indicating if calendar integration should be enabled.
  /// Default: enabled (true) on Android, auto-detected on iOS.
  isCalendarEnabled,

  /// Flag indicating if call integration (CallKit on iOS, ConnectionService on Android)
  /// should be enabled.
  /// Default: enabled (true).
  isCallIntegrationEnabled,

  /// Flag indicating if close captions should be enabled.
  /// Default: enabled (true).
  isCloseCaptionsEnabled,

  /// Flag indicating if conference timer should be enabled.
  /// Default: enabled (true).
  isConferenceTimerEnabled,

  /// Flag indicating if chat should be enabled.
  /// Default: enabled (true).
  isChatEnabled,

  /// Flag indicating if the filmstrip should be enabled.
  /// Default: enabled (true).
  isFilmstripEnabled,

  // TODO(saibotma): Test whether this works with the theme set on the android activity.
  /// Flag indicating if fullscreen (immersive) mode should be enabled.
  /// Default: enabled (true).
  isFullscreenEnabled,

  /// Flag indicating if the Help button should be enabled.
  /// Default: enabled (true).
  isHelpButtonEnabled,

  /// Flag indicating if invite functionality should be enabled.
  /// Default: enabled (true).
  isInviteEnabled,

  /// Flag indicating if recording should be enabled in iOS.
  /// Default: disabled (false).
  isIosRecordingEnabled,

  /// Flag indicating if screen sharing should be enabled in iOS.
  /// Default: disabled (false).
  isIosScreensharingEnabled,

  /// Flag indicating if screen sharing should be enabled in android.
  /// Default: enabled (true).
  isAndroidScreensharingEnabled,

  /// Flag indicating if kickout is enabled.
  /// Default: enabled (true).
  isKickoutEnabled,

  /// Flag indicating if live-streaming should be enabled.
  /// Default: auto-detected.
  isLiveStreamingEnabled,

  /// Flag indicating if lobby mode button should be enabled.
  /// Default: enabled.
  isLobbyModeEnabled,

  /// Flag indicating if displaying the meeting name should be enabled.
  /// Default: enabled (true).
  isMeetingNameEnabled,

  /// Flag indicating if the meeting password button should be enabled.
  /// Note that this flag just decides on the button, if a meeting has a password
  /// set, the password dialog will still show up.
  /// Default: enabled (true).
  isMeetingPasswordEnabled,

  /// Flag indicating if the notifications should be enabled.
  /// Default: enabled (true).
  isNotificationsEnabled,

  /// Flag indicating if the audio overflow menu button should be displayed.
  /// Default: enabled (true).
  isOverflowMenuEnabled,

  /// Flag indicating if Picture-in-Picture should be enabled.
  /// Default: auto-detected.
  isPipEnabled,

  /// Flag indicating if raise hand feature should be enabled.
  /// Default: enabled.
  isRaiseHandEnabled,

  /// Flag indicating if the reactions feature should be enabled.
  /// Default: enabled (true).
  isReactionsEnabled,

  /// Flag indicating if recording should be enabled.
  /// Default: auto-detected.
  isRecordingEnabled,

  /// Flag indicating if the user should join the conference with the replaceParticipant functionality.
  /// Default: (false).
  isReplaceParticipantEnabled,

  /// Flag indicating the local and (maximum) remote video resolution. Overrides
  /// the server configuration.
  /// Default: (unset).
  resolution,

  /// Flag indicating if the security options button should be enabled.
  /// Default: enabled (true).
  areSecurityOptionsEnabled,

  /// Flag indicating if server URL change is enabled.
  /// Default: enabled (true).
  isServerUrlChangeEnabled,

  /// Flag indicating if tile view feature should be enabled.
  /// Default: enabled.
  isTileViewEnabled,

  /// Flag indicating if the toolbox should be always be visible
  /// Default: disabled (false).
  isToolboxAlwaysVisible,

  /// Flag indicating if the toolbox should be enabled
  /// Default: enabled.
  isToolboxEnabled,

  /// Flag indicating if the video mute button should be displayed.
  /// Default: enabled (true).
  isVideoMuteButtonEnabled,

  /// Flag indicating if the video share button should be enabled
  /// Default: enabled (true).
  isVideoShareButtonEnabled,

  /// Flag indicating if the welcome page should be enabled.
  /// Default: disabled (false).
  isWelcomePageEnabled,
}
