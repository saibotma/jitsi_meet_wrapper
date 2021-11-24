# jitsi_meet_wrapper

Jitsi Meet Plugin for Flutter. Wrapping JitsiMeetSDK for
[Android](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk) and
[iOS](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk).

This wrapper got built for [Appella](https://www.appella.app/) App. The goal is to keep it generic, however at the
moment it only contains features needed in Appella.
I am happy to review PRs that add additional functionality to this plugin however it is not
guaranteed that I will have time to develop and add features that are not needed in Appella.
Nevertheless please always create an issue and I will have a look.

## Table of Contents
  - [Join A Meeting](#join-a-meeting)
  - [Configuration](#configuration)
    - [iOS](#ios)
    - [Android](#android)

<a name="join-a-meeting"></a>
## Join A Meeting

To join a meeting you have to create meeting options and then launch the meeting:

```dart
var options = JitsiMeetingOptions(roomName: "my-room");
await JitsiMeetWrapper.joinMeeting(options);
```

Take a look at [`JitsiMeetingOptions`](https://github.com/saibotma/jitsi_meet_wrapper/blob/main/jitsi_meet_wrapper_platform_interface/lib/jitsi_meeting_options.dart)
for all the available options.

<a name="configuration"></a>
## Configuration

Most recommendations below are based on the
official documentation of the JitsiMeetSDK for [iOS](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-ios-sdk)
and [Android](https://jitsi.github.io/handbook/docs/dev-guide/dev-guide-android-sdk).
Taking a look at them is recommended, if you have any issues or need detailed information.

<a name="ios"></a>
### iOS
Note: The example app does not compile on simulator at the moment. (https://github.com/saibotma/jitsi_meet_wrapper/issues/2)

#### Podfile

The platform needs to be set to `11.0` or newer and bitcode needs to be disabled.
The file should look similar to below:

```
platform :ios, '11.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

#### Info.plist
Add `NSCameraUsageDescription` and `NSMicrophoneUsageDescription` to your `Info.plist`.
In order for you app to properly work in the background, select the `audio` and `voip` background modes.
Additionally it is recommended to set `UIViewControllerBasedStatusBarAppearance` to `NO`.

```text
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
Update your minimum sdk version to `23` in `android/app/build.gradle`.

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
