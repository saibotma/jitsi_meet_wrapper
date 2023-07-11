## 0.1.0
- **Breaking:** Remove `FeatureFlag` enum to reduce maintenance effort; Feature flags can still be set by using the native feature flag name as explained in the documentation of `JitsiMeetingOptions.featureFlags` [9718c87](https://github.com/saibotma/jitsi_meet_wrapper/commit/9718c879dd099b9de3f049aca6c3df19b58d618b)

## 0.0.5
- Add `isPrejoinPageEnabled` feature flag [aac9f2f](https://github.com/saibotma/jitsi_meet_wrapper/commit/aac9f2fa61e531499674dc1a1288784ae4752c0b)

## 0.0.4

- Add option to `setAudioMuted` [#56](https://github.com/saibotma/jitsi_meet_wrapper/pull/56)
- Add option to `hangUp` [#56](https://github.com/saibotma/jitsi_meet_wrapper/pull/56)

## 0.0.3

- Remove `pubspec.lock`
  file [1aa6203c67ef7a63accf2c6be397c70ca8f5d2c4](https://github.com/saibotma/jitsi_meet_wrapper/commit/1aa6203c67ef7a63accf2c6be397c70ca8f5d2c4)

## 0.0.2

- Add more conference events: `onAudioMutedChanged`, `onVideoMutedChanged`, `onScreenShareToggled`
  , `onParticipantJoined`, `onParticipantLeft`,  `onParticipantsInfoRetrieved`, `onChatMessageReceived`
  , `onChatToggled` [#18](https://github.com/saibotma/jitsi_meet_wrapper/pull/18)

## 0.0.1

- Initial version
