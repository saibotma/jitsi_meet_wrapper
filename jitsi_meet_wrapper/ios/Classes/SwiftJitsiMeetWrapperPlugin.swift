import Flutter
import UIKit
import JitsiMeetSDK

public class SwiftJitsiMeetWrapperPlugin: NSObject, FlutterPlugin {
    var flutterViewController: UIViewController
    var jitsiViewController: JitsiMeetWrapperViewController?

    init(flutterViewController: UIViewController) {
        self.flutterViewController = flutterViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "jitsi_meet_wrapper", binaryMessenger: registrar.messenger())
        let flutterViewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        let instance = SwiftJitsiMeetWrapperPlugin(flutterViewController: flutterViewController)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "joinMeeting") {
            joinMeeting(call, result: result)
            return
        }
    }

    private func joinMeeting(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        jitsiViewController = JitsiMeetWrapperViewController.init()
        let arguments = call.arguments as! [String: Any]

        let roomName = arguments["roomName"] as! String
        if (roomName.trimmingCharacters(in: .whitespaces).isEmpty) {
            result(FlutterError.init(
                    code: "400",
                    message: "room is empty in arguments for method: joinMeeting",
                    details: "room is empty in arguments for method: joinMeeting"
            ))
            return
        }
        jitsiViewController?.roomName = roomName;

        // Otherwise uses default public jitsi meet URL
        if let serverUrl = arguments["serverUrl"] as? String {
            jitsiViewController?.serverUrl = URL(string: serverUrl);
        }

        let subject = arguments["subject"] as? String
        jitsiViewController?.subject = subject;

        let token = arguments["token"] as? String
        jitsiViewController?.token = token;

        if let isAudioMuted = arguments["isAudioMuted"] as? Int {
            let isAudioMutedBool = isAudioMuted > 0 ? true : false
            jitsiViewController?.audioMuted = isAudioMutedBool;
        }

        // TODO(saibotma): Why int and not bool?
        if let isAudioOnly = arguments["isAudioOnly"] as? Int {
            let isAudioOnlyBool = isAudioOnly > 0 ? true : false
            jitsiViewController?.audioOnly = isAudioOnlyBool;
        }

        if let isVideoMuted = arguments["isVideoMuted"] as? Int {
            let isVideoMutedBool = isVideoMuted > 0 ? true : false
            jitsiViewController?.videoMuted = isVideoMutedBool;
        }

        let displayName = arguments["userDisplayName"] as? String
        jitsiViewController?.jistiMeetUserInfo.displayName = displayName;

        let email = arguments["userEmail"] as? String
        jitsiViewController?.jistiMeetUserInfo.email = email;

        if let avatarUrl = arguments["userAvatarUrl"] as? String {
            jitsiViewController?.jistiMeetUserInfo.avatar = URL(string: avatarUrl);
        }

        let featureFlags = arguments["featureFlags"] as! Dictionary<String, Any>
        jitsiViewController?.featureFlags = featureFlags;

        // TODO(saibotma): Build JitsiMeetConferenceOptions directly like in android implementation
        let navigationController = UINavigationController(rootViewController: (jitsiViewController)!)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barTintColor = UIColor.black
        flutterViewController.present(navigationController, animated: true)
        result(nil)
    }
}
