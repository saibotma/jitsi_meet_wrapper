import Flutter
import UIKit

public class SwiftJitsiMeetWrapperPlugin: NSObject, FlutterPlugin {
    var window: UIWindow?
    var uiVC: UIViewController
    var jitsiViewController: JitsiViewController?

    init(uiViewController: UIViewController) {
        uiVC = uiViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "jitsi_meet_wrapper", binaryMessenger: registrar.messenger())
        let viewController: UIViewController =
                (UIApplication.shared.delegate?.window??.rootViewController)!
        let instance = SwiftJitsiMeetWrapperPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "joinMeeting") {
            joinMeeting(call, result: result)
            return
        }

        if (call.method == "closeMeeting") {
            closeMeeting(call, result: result)
            return
        }
    }

    private func joinMeeting(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        jitsiViewController = JitsiViewController.init()
        jitsiViewController?.eventSink = eventSink;

        guard let args = call.arguments else {
            return
        }

        if let myArgs = args as? [String: Any] {
            if let roomName = myArgs["roomName"] as? String {
                if let serverUrl = myArgs["serverUrl"] as? String {
                    jitsiViewController?.serverUrl = URL(string: serverUrl);
                }
                let subject = myArgs["subject"] as? String
                let token = myArgs["token"] as? String

                jitsiViewController?.roomName = roomName;

                if let isAudioMuted = myArgs["isAudioMuted"] as? Int {
                    let isAudioMutedBool = isAudioMuted > 0 ? true : false
                    jitsiViewController?.audioMuted = isAudioMutedBool;
                }

                // TODO(saibotma): Why int and not bool?
                if let isAudioOnly = myArgs["isAudioOnly"] as? Int {
                    let isAudioOnlyBool = isAudioOnly > 0 ? true : false
                    jitsiViewController?.audioOnly = isAudioOnlyBool;
                }

                if let isVideoMuted = myArgs["isVideoMuted"] as? Int {
                    let isVideoMutedBool = isVideoMuted > 0 ? true : false
                    jitsiViewController?.videoMuted = isVideoMutedBool;
                }

                let displayName = myArgs["userDisplayName"] as? String
                jitsiViewController?.jistiMeetUserInfo.displayName = displayName;

                let email = myArgs["userEmail"] as? String
                jitsiViewController?.jistiMeetUserInfo.email = email;

                jitsiViewController?.subject = subject;
                jitsiViewController?.token = token;

                if let avatarURL = myArgs["userAvatarURL"] as? String {
                    jitsiViewController?.jistiMeetUserInfo.avatar = URL(string: avatarURL);
                }

                if let featureFlags = myArgs["featureFlags"] as? Dictionary<String, Any> {
                    jitsiViewController?.featureFlags = featureFlags;
                }

            } else {
                result(FlutterError.init(code: "400", message: "room is null in arguments for method: (joinMeeting)", details: "room is null in arguments for method: (joinMeeting)"))
            }
        } else {
            result(FlutterError.init(code: "400", message: "arguments are null for method: (joinMeeting)", details: "arguments are null for method: (joinMeeting)"))
        }

        let navigationController = UINavigationController(rootViewController: (self.jitsiViewController)!)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.barTintColor = UIColor.black
        uiVC.present(navigationController, animated: true)
        result(nil)
    }

    private func closeMeeting(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var dictClosingServerInfo: Dictionary = Dictionary<AnyHashable, Any>()
        let serverURL: String = jitsiViewController?.serverUrl?.absoluteString ?? ""
        let roomName: String = jitsiViewController?.roomName ?? ""

        dictClosingServerInfo["url"] = "\(serverURL)/\(roomName)";

        jitsiViewController?.closeJitsiMeeting();
        jitsiViewController?.conferenceTerminated(dictClosingServerInfo);
    }
}
