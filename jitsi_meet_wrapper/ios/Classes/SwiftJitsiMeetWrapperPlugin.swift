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
            jitsiViewController = JitsiViewController.init()
            jitsiViewController?.eventSink = eventSink;

            guard let args = call.arguments else {
                return
            }

            if let myArgs = args as? [String: Any] {
                if let roomName = myArgs["room"] as? String {
                    if let serverURL = myArgs["serverURL"] as? String {
                        jitsiViewController?.serverUrl = URL(string: serverURL);
                    }
                    let subject = myArgs["subject"] as? String
                    let displayName = myArgs["userDisplayName"] as? String
                    let email = myArgs["userEmail"] as? String
                    let token = myArgs["token"] as? String

                    jitsiViewController?.roomName = roomName;
                    jitsiViewController?.subject = subject;
                    jitsiViewController?.jistiMeetUserInfo.displayName = displayName;
                    jitsiViewController?.jistiMeetUserInfo.email = email;
                    jitsiViewController?.token = token;

                    if let avatarURL = myArgs["userAvatarURL"] as? String {
                        jitsiViewController?.jistiMeetUserInfo.avatar = URL(string: avatarURL);
                    }

                    // TODO(saibotma): Why int and not bool?
                    if let audioOnly = myArgs["audioOnly"] as? Int {
                        let audioOnlyBool = audioOnly > 0 ? true : false
                        jitsiViewController?.audioOnly = audioOnlyBool;
                    }

                    if let audioMuted = myArgs["audioMuted"] as? Int {
                        let audioMutedBool = audioMuted > 0 ? true : false
                        jitsiViewController?.audioMuted = audioMutedBool;
                    }

                    if let videoMuted = myArgs["videoMuted"] as? Int {
                        let videoMutedBool = videoMuted > 0 ? true : false
                        jitsiViewController?.videoMuted = videoMutedBool;
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
        } else if (call.method == "closeMeeting") {
            var dictClosingServerInfo: Dictionary = Dictionary<AnyHashable, Any>()
            let serverURL: String = jitsiViewController?.serverUrl?.absoluteString ?? ""
            let roomName: String = jitsiViewController?.roomName ?? ""

            dictClosingServerInfo["url"] = "\(serverURL)/\(roomName)";

            jitsiViewController?.closeJitsiMeeting();
            jitsiViewController?.conferenceTerminated(dictClosingServerInfo);
        }
    }
}
