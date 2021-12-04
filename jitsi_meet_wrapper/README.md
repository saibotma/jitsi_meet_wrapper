# jitsi_meet_wrapper

Jitsi Meet Plugin for Flutter.<br>
Wrapping JitsiMeetSDK for
[Android](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk) and
[iOS](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk).

This wrapper got built for [Appella](https://www.appella.app/) App. The goal is to keep it generic, however at the
moment, it only contains features needed in Appella.
I am happy to review PRs that add additional functionality to this plugin, however it is not
guaranteed that I will have time to develop and add features that are not needed in Appella.<br>
Nevertheless, please always create an issue and I will try to have a look.

## Table of Contents
  - [Join A Meeting](#join-a-meeting)
  - [Configuration](#configuration)
    - [iOS](#ios)
    - [Android](#android)
  - [Listening to meeting events](#listening-to-meeting-events)
  - [Known issues](#known-issues)

<a name="join-a-meeting"></a>
## Join A Meeting

To join a meeting, you have to create meeting options and then launch the meeting:

```dart
var options = JitsiMeetingOptions(roomName: "my-room");
await JitsiMeetWrapper.joinMeeting(options);
```

Take a look at [`JitsiMeetingOptions`](https://github.com/saibotma/jitsi_meet_wrapper/blob/main/jitsi_meet_wrapper_platform_interface/lib/jitsi_meeting_options.dart)
for all the available options.

<a name="configuration"></a>
## Configuration

Most recommendations below are based on the
official documentation of JitsiMeetSDK for [iOS](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk)
It is recommended to take a look at them, if you have any issues or need more detailed information.

<a name="ios"></a>
### iOS
Note: The example app does not compile on simulator at the moment. (https://github.com/saibotma/jitsi_meet_wrapper/issues/2)

#### Podfile

The platform (and also the deployment target) needs to be set to `11.0` or newer and bitcode needs to be disabled.<br>
The file should look similar to below:

```
platform :ios, '12.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

#### Info.plist
Add `NSCameraUsageDescription` and `NSMicrophoneUsageDescription` to your `Info.plist`.<br>
In order for your app to properly work in the background, select the `audio` and `voip` background modes.<br>
Additionally, it is recommended to set `UIViewControllerBasedStatusBarAppearance` to `NO`.<br>

```xml
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) needs access to the camera for meetings.</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) needs access to the microphone for meetings.</string>
<key>UIBackgroundModes</key>
<array>
	<string>audio</string>
	<string>voip</string>
</array>
<key>UIViewControllerBasedStatusBarAppearance</key>
<false/>
```

#### Screen sharing
To enable screen sharing on iOS, you have to add a "Broadcast Upload Extension" to YOUR app. That's why we can't add it to the plugin by default.
Don't be afraid of implementing this, it is actually very easy.

The steps presented below are a summary of the very detailed explanation in the [official docs](https://github.com/jitsi/handbook/blob/75d38b5a3db9d44ff60feb7c72dd6f7d4a5ea83c/docs/dev-guide/ios-sdk.md#screen-sharing-integration). They are tested to work with this version of the plugin.
- Add another target of the type "Broadcast Upload Extension" (BT) as shown in the screenshot. ![screenshot 1](https://github.com/jitsi/handbook/blob/c105fe0782e272875b36dd763fa54f19dd91c9a7/docs/assets/iOS_screensharing_1.png)
- Copy the files from `jitsi_meet_wrapper/example/ios/Broadcast Extension/` into the folder of your newly created BT.
- Set the deployment target of BT to 14 or above.
- Create an app group for BT and the "Runner" target (RT) and add both targets to this app group.
- Replace `appGroupIdentifier` in `SampleHandler.swift` with your app group name.
- Add the key value pairs `RTCAppGroupIdentifier` with the name of your app group and `RTCScreenSharingExtension` with the bundle identifier of BT to `Info.plist` of RT.
- Don't forget to enable the feature flag `FeatureFlag.isIosScreensharingEnabled` when joining the meeting in Dart code.
- Make sure that `voip` is set as `UIBackgroundModes` in `Info.plist` of RT.


Most of the above steps have already been executed on the example app in this repository. However, the app group was not created yet, as this requires a development team to be set.
You can however execute some simple steps in to make screen sharing work on the example app:
- Add a development team.
- Create an app group with the name `group.dev.saibotma.jitsi-meet-wrapper-example.appgroup`.
- Add the app group to both the "Runner" and the "Broadcast Extension" target.
- Add the feature flag `FeatureFlag.isIosScreensharingEnabled: true` in `_joinMeeting` in `main.dart` of the example app.
- Run the app...

Screen sharing is available for applications running on iOS 14 or newer. The deployment target of your app ("Runner" target) may be lower, though. Those devices will just not be able to share their screen.


<a name="android"></a>
### Android
#### AndroidManifest.xml

JitsiMeetSDKs AndroidManifest.xml will conflict with your project, namely
the `android:label` field. To counter that, go into
`android/app/src/main/AndroidManifest.xml` and add the tools library
and `tools:replace="android:label"` to the application tag.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools" <!-- Add this -->
          package="your.package.name">
    <application tools:replace="android:label" <!-- Add this -->
                 android:name="your.app.name"
                 android:label="your app name"
                 android:icon="@mipmap/ic_launcher">
                 ...
    </application>
    ...
</manifest>
```

#### build.gradle
Update your minimum SDK version to `23` in `android/app/build.gradle`.

```groovy
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 23 // Change this
        ...
    }
    ...
}
```

<a name="listening-to-meeting-events"></a>
## Listening to Meeting Events

Supported events:

| Name                   | Description  |
| :--------------------- | :----------- |
| onConferenceWillJoin   | Called before a conference is joined. |
| onConferenceJoined     | Called when a conference was joined. |
| onConferenceTerminated | Called when a conference was terminated either by user choice or due to a failure. |

There are many more events ([Android](https://github.com/jitsi/handbook/blob/75d38b5a3db9d44ff60feb7c72dd6f7d4a5ea83c/docs/dev-guide/android-sdk.md#supported-events), [iOS](https://github.com/jitsi/handbook/blob/75d38b5a3db9d44ff60feb7c72dd6f7d4a5ea83c/docs/dev-guide/ios-sdk.md#jitsimeetviewdelegate)), however we don't support them currently. <br>
It is straight forward to add them, so don't hesitate to submit a PR.

### Per Meeting Events
To listen to meeting events per meeting, pass in a `JitsiMeetingListener`
to `joinMeeting`. The listener will automatically be removed when the conference is over
(which is not `onConferenceTerminated`).

```
await JitsiMeetWrapper.joinMeeting(
  options: options,
  listener: JitsiMeetingListener(
    onConferenceWillJoin: (url) => print("onConferenceWillJoin: url: $url"),
    onConferenceJoined: (url) => print("onConferenceJoined: url: $url"),
    onConferenceTerminated: (url, error) => print("onConferenceTerminated: url: $url, error: $error"),
  ),
);
```

<a name="known-issues"></a>
### Known issues
- Picture in Picture is not working during screen sharing (https://github.com/jitsi/jitsi-meet/issues/9099)

