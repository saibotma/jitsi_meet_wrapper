import Flutter
import UIKit
import JitsiMeetSDK

public class SwiftJitsiMeetWrapperPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    var flutterViewController: UIViewController
    var jitsiViewController: JitsiMeetWrapperViewController?
    var eventSink: FlutterEventSink?

    init(flutterViewController: UIViewController) {
        self.flutterViewController = flutterViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "jitsi_meet_wrapper", binaryMessenger: registrar.messenger())
        let flutterViewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let instance = SwiftJitsiMeetWrapperPlugin(flutterViewController: flutterViewController)
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Setup event channel for conference events
        let eventChannel = FlutterEventChannel(name: "jitsi_meet_wrapper_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "joinMeeting") {
            joinMeeting(call, result: result)
            return
        } else if (call.method == "setAudioMuted") {
            setAudioMuted(call, result: result)
            return
        } else if (call.method == "hangUp") {
            hangUp(call, result: result)
            return
        }
    }

    private func joinMeeting(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // As a general rule: Don't set options when they are null as
        // this could override (reset) configurations from the URL.

        let arguments = call.arguments as! [String: Any]

        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            let roomName = arguments["roomName"] as! String
            if (roomName.trimmingCharacters(in: .whitespaces).isEmpty) {
                result(FlutterError.init(
                        code: "400",
                        message: "room is empty in arguments for method: joinMeeting",
                        details: "room is empty in arguments for method: joinMeeting"
                ))
                return
            }
            builder.room = roomName

            // Otherwise uses default public jitsi meet URL
            if let serverUrl = arguments["serverUrl"] as? String {
                builder.serverURL = URL(string: serverUrl);
            }

            if let subject = arguments["subject"] as? String {
                builder.setSubject(subject)
            }

            if let token = arguments["token"] as? String {
                builder.token = token;
            }

            if let isAudioMuted = arguments["isAudioMuted"] as? Bool {
                builder.setAudioMuted(isAudioMuted);
            }

            if let isAudioOnly = arguments["isAudioOnly"] as? Bool {
                builder.setAudioOnly(isAudioOnly)
            }

            if let isVideoMuted = arguments["isVideoMuted"] as? Bool {
                builder.setVideoMuted(isVideoMuted)
            }

            let displayName = arguments["userDisplayName"] as? String
            let email = arguments["userEmail"] as? String
            let avatarUrlString = arguments["userAvatarUrl"] as? String

            if (displayName != nil || email != nil || avatarUrlString != nil) {
                let avatarUrl = avatarUrlString != nil ? URL(string: avatarUrlString!) : nil
                builder.userInfo = JitsiMeetUserInfo(displayName: displayName, andEmail: email, andAvatar: avatarUrl)
            }

            let featureFlags = arguments["featureFlags"] as? Dictionary<String, Any>
            featureFlags?.forEach { key, value in
                builder.setFeatureFlag(key, withValue: value);
            }

            let configOverrides = arguments["configOverrides"] as? Dictionary<String, Any>
            configOverrides?.forEach { key, value in
                builder.setConfigOverride(key, withValue: value);
            }
        }

        jitsiViewController = JitsiMeetWrapperViewController.init(options: options, eventSink: eventSink!)

        // In order to make pip mode work.
        jitsiViewController!.modalPresentationStyle = .overFullScreen
        flutterViewController.present(jitsiViewController!, animated: true)
        result(nil)
    }
    
    private func setAudioMuted(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! [String: Any]
        let isMuted = arguments["isMuted"] as? Bool ?? false
        jitsiViewController?.sourceJitsiMeetView?.setAudioMuted(isMuted)
        result(nil)
    }

    private func hangUp(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        jitsiViewController?.sourceJitsiMeetView?.hangUp()
        result(nil)
    }

    // FlutterStreamHandler methods

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
