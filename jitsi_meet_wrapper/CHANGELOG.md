## 0.2.0+1
- Remove custom PiP implementation on iOS [b61dd6c](https://github.com/saibotma/jitsi_meet_wrapper/commit/b61dd6c1a0d34967ec5f8f14f79915dadfb27561)

## 0.2.0
- **Breaking:** Remove `FeatureFlag` enum to reduce maintenance effort; Feature flags can still be set by using the native feature flag name as explained in the documentation of `JitsiMeetingOptions.featureFlags` [9718c87](https://github.com/saibotma/jitsi_meet_wrapper/commit/9718c879dd099b9de3f049aca6c3df19b58d618b)
- Fix bug that would open a second activity when tapping the Android background notification [c9d04dc](https://github.com/saibotma/jitsi_meet_wrapper/commit/c9d04dcc72a2dc6c5d01e7139e375ef9b0f571d5)

## 0.1.2
- Add `isPrejoinPageEnabled` feature flag [aac9f2f](https://github.com/saibotma/jitsi_meet_wrapper/commit/aac9f2fa61e531499674dc1a1288784ae4752c0b)

## 0.1.1
- Fix typo in readme [3297349](https://github.com/saibotma/jitsi_meet_wrapper/commit/3297349c665259946925b345de65180ef232ef92)

## 0.1.0
- **Breaking:** Bump SDK version to 8.1.2; This requires Android `minSdkVersion` of 24 [7932c59](https://github.com/saibotma/jitsi_meet_wrapper/commit/7932c59efcd37d208173a8e18ea47984e299670d)

## 0.0.6
- Clean up pubspec.yaml [#30](https://github.com/saibotma/jitsi_meet_wrapper/pull/30)
- Fix feature flag String mapping of `FEatureFlag.isToolboxEnabled` [#45](https://github.com/saibotma/jitsi_meet_wrapper/pull/45)
- Add option to `setAudioMuted` [#56](https://github.com/saibotma/jitsi_meet_wrapper/pull/56)
- Add option to `hangUp` [#56](https://github.com/saibotma/jitsi_meet_wrapper/pull/56)
- Bump SDK version to [7.0.1](https://github.com/jitsi/jitsi-meet-release-notes/blob/master/CHANGELOG-MOBILE-SDKS.md#701-2022-12-08)
- Support Android 13 [#60](https://github.com/saibotma/jitsi_meet_wrapper/pull/60)
- Bump Kotlin and Gradle versions [#60](https://github.com/saibotma/jitsi_meet_wrapper/pull/60)
- Remove known issue that this plugin will not work on iOS simulator

## 0.0.5
- Fix wrong min iOS version in documentation [#28](https://github.com/saibotma/jitsi_meet_wrapper/pull/28)
- Remove `pubspec.lock` files [1aa6203c67ef7a63accf2c6be397c70ca8f5d2c4](https://github.com/saibotma/jitsi_meet_wrapper/commit/1aa6203c67ef7a63accf2c6be397c70ca8f5d2c4)

## 0.0.4

- Bump SDK version
  to [5.0.2](https://github.com/jitsi/jitsi-meet-release-notes/blob/master/CHANGELOG-MOBILE-SDKS.md#502-2022-03-29) [#19](https://github.com/saibotma/jitsi_meet_wrapper/pull/19)
- Add more conference events: `onAudioMutedChanged`, `onVideoMutedChanged`, `onScreenShareToggled`
  , `onParticipantJoined`, `onParticipantLeft`,  `onParticipantsInfoRetrieved`, `onChatMessageReceived`
  , `onChatToggled` [#18](https://github.com/saibotma/jitsi_meet_wrapper/pull/18)

## 0.0.3

- Bump SDK version
  to [5.0.0](https://github.com/jitsi/jitsi-meet-release-notes/blob/master/CHANGELOG-MOBILE-SDKS.md#500-2022-03-02)

## 0.0.2

- Bump SDK version
  to [4.1.0](https://github.com/jitsi/jitsi-meet-release-notes/blob/master/CHANGELOG-MOBILE-SDKS.md#410-2021-12-14)

## 0.0.1

- Initial version
