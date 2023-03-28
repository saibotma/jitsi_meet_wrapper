import Flutter
import UIKit
import JitsiMeetSDK

class JitsiViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    
    init(messenger:FlutterBinaryMessenger){
        
        self.messenger = messenger
        super.init()
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return JitsiView(frame: frame, viewId: viewId, args: args, binaryMessenger: messenger)
    }
}

class JitsiView: NSObject, FlutterPlatformView {
    private var _jitsiMeetView: JitsiMeetView
    private var _options: JitsiMeetConferenceOptions
    private var _methodChannel: FlutterMethodChannel
    
    let frame: CGRect
    let viewId: Int64
    var eventSink : FlutterEventSink?
    var passArgs : Any?
    
    init(
        frame: CGRect,
        viewId: Int64,
        args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            if let jitsiOptions = args as? [String:Any]   {
                
                // set options which is received from flutter
                let isAudioOnly = jitsiOptions["isAudioOnly"] as? Bool
                let isAudioMuted = jitsiOptions["isAudioMuted"] as? Bool
                let isVideoMuted = jitsiOptions["isVideoMuted"] as? Bool
                let roomNameOrUrl = jitsiOptions["roomNameOrUrl"] as? String
                let serverUrl = jitsiOptions["serverUrl"] as? String
                let subject = jitsiOptions["subject"] as? String
                let userDisplayName = jitsiOptions["userDisplayName"] as? String
                let userEmail = jitsiOptions["userEmail"] as? String

                let token = jitsiOptions["token"] as? String
                
                // UserInfo Update param from flutter
                let userInfo = JitsiMeetUserInfo()
                userInfo.displayName = userDisplayName
                userInfo.email = userEmail
                
                builder.room = roomNameOrUrl
                builder.setAudioOnly(isAudioOnly ?? true)
                builder.setAudioMuted(isAudioMuted ?? true)
                builder.setVideoMuted(isVideoMuted ?? true)
                if(subject?.isEmpty == false) {
                    builder.setSubject(subject!)
                }
                if(token?.isEmpty == false) {
                    builder.token =  token
                }
                builder.serverURL = URL.init(string: serverUrl ?? "https://meet.jit.si")
                builder.userInfo = userInfo
                builder.setFeatureFlag("prejoinpage.enabled", withBoolean: false)
                
                
                if let featureFlag = jitsiOptions["featureFlags"] as? [String:Any] {
                    for (key, value) in featureFlag {
                        builder.setFeatureFlag(key, withValue: value)
                    }
                }
            }
        }
        
        _jitsiMeetView = JitsiMeetView()
        _methodChannel = FlutterMethodChannel(name: "plugins.jitsi_meet_wrapper/jitsi_meet_native_view_\(viewId)", binaryMessenger: messenger!)

        self.frame = frame
        self.viewId = viewId
        self.passArgs = args
        
        super.init()
        _methodChannel.setMethodCallHandler(onMethodCall)
    }
    
    func view() -> UIView {
        _jitsiMeetView.delegate = self
        EventManager.shared.eventSink?(["event": "opened"])
        return _jitsiMeetView
    }

    
    func onMethodCall(call: FlutterMethodCall, result: FlutterResult) {
        switch(call.method){
           case "join":
             join( call, result: result)
            
           case "hangUp":
                hangUp( call, result: result)
            
           case "setAudioMuted":
                setAudioMuted(call, result: result)
           default:
               result(FlutterMethodNotImplemented)
           }
       }
    
    private func join(_ call: FlutterMethodCall, result: FlutterResult){
        _jitsiMeetView.join(_options)
        result(nil)

    }
    
    private func hangUp(_ call: FlutterMethodCall, result: FlutterResult){
       _jitsiMeetView.hangUp()
       result(nil)

   }
    
    private func setAudioMuted(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as! [String: Any]
        let isMuted = arguments["isMuted"] as? Bool ?? false
        _jitsiMeetView.setAudioMuted(isMuted)
        result(nil)
    }
    
}


extension JitsiView: JitsiMeetViewDelegate {
    func conferenceJoined(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "conferenceJoined", "data": data])
    }
    
    func conferenceTerminated(_ data: [AnyHashable: Any]) {
        EventManager.shared.eventSink?(["event": "conferenceTerminated", "data": data])
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "conferenceWillJoin", "data": data])
    }

    func participantJoined(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "participantJoined", "data": data])
    }
    
    func participantLeft(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "participantLeft", "data": data])
    }
    
    func audioMutedChanged(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "audioMutedChanged", "data": data])
    }
    
    func endpointTextMessageReceived(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "endpointTextMessageReceived", "data": data])
    }
    
    func screenShareToggled(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "screenShareToggled", "data": data])
    }
    
    func chatMessageReceived(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "chatMessageReceived", "data": data])
    }
    
    func chatToggled(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "chatToggled", "data": data])
    }
    
    func videoMutedChanged(_ data: [AnyHashable : Any]) {
        EventManager.shared.eventSink?(["event": "videoMutedChanged", "data": data])
    }
}
