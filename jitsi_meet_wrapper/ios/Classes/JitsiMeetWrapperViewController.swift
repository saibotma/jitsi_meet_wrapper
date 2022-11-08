import UIKit
import JitsiMeetSDK

// This is closely inspired by:
// https://github.com/jitsi/jitsi-meet-sdk-samples/blob/18c35f7625b38233579ff34f761f4c126ba7e03a/ios/swift-pip/JitsiSDKTest/src/ViewController.swift
class JitsiMeetWrapperViewController: UIViewController {
    fileprivate var pipViewCoordinator: CustomPiPViewCoordinator?
    fileprivate var jitsiMeetView: UIView?
    var sourceJitsiMeetView: JitsiMeetView?

    let options: JitsiMeetConferenceOptions
    let eventSink: FlutterEventSink

    // https://stackoverflow.com/a/55208383/6172447
    init(options: JitsiMeetConferenceOptions, eventSink: @escaping FlutterEventSink) {
        self.options = options;
        self.eventSink = eventSink;
        // Need to pass in nibName and bundle otherwise an error occurs.
        super.init(nibName: nil, bundle: nil)
    }

    // https://stackoverflow.com/a/55208383/6172447
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventSink(["event": "opened"])
        // Open Jitsi in viewDidLoad as it should only be opened once per view controller.
        openJitsiMeet();
    }

    func openJitsiMeet() {
        cleanUp()

        sourceJitsiMeetView = JitsiMeetView()
        // Need to wrap the jitsi view in another view that absorbs all the pointer events
        // because of a flutter bug: https://github.com/flutter/flutter/issues/14720
        let jitsiMeetView = AbsorbPointersView()
        jitsiMeetView.backgroundColor = .black
        self.jitsiMeetView = jitsiMeetView

        jitsiMeetView.addSubview(sourceJitsiMeetView!)

        // Make the jitsi view redraw when orientation changes.
        // From: https://stackoverflow.com/a/45860445/6172447
        sourceJitsiMeetView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        sourceJitsiMeetView!.delegate = self
        sourceJitsiMeetView!.join(options)

        // Pip only works inside the app and not OS wide at the moment:
        // https://github.com/jitsi/jitsi-meet/issues/3515#issuecomment-427846699
        //
        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = CustomPiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let rect = CGRect(origin: CGPoint.zero, size: size)
        pipViewCoordinator?.resetBounds(bounds: rect)
    }

    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
        sourceJitsiMeetView = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.eventSink(["event": "closed"])
    }
}

extension JitsiMeetWrapperViewController: JitsiMeetViewDelegate {
    func ready(toClose data: [AnyHashable : Any]) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.hide { _ in
                self.cleanUp()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "conferenceJoined", "data": data])
    }
    
    func conferenceTerminated(_ data: [AnyHashable: Any]) {
        self.eventSink(["event": "conferenceTerminated", "data": data])
    }
    
    func conferenceWillJoin(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "conferenceWillJoin", "data": data])
    }

    func enterPicture(inPicture data: [AnyHashable: Any]) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
    
    func participantJoined(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "participantJoined", "data": data])
    }
    
    func participantLeft(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "participantLeft", "data": data])
    }
    
    func audioMutedChanged(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "audioMutedChanged", "data": data])
    }
    
    func endpointTextMessageReceived(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "endpointTextMessageReceived", "data": data])
    }
    
    func screenShareToggled(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "screenShareToggled", "data": data])
    }
    
    func chatMessageReceived(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "chatMessageReceived", "data": data])
    }
    
    func chatToggled(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "chatToggled", "data": data])
    }
    
    func videoMutedChanged(_ data: [AnyHashable : Any]) {
        self.eventSink(["event": "videoMutedChanged", "data": data])
    }
}

// This is based on https://github.com/flutter/flutter/issues/35784#issuecomment-516274701.
class AbsorbPointersView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
