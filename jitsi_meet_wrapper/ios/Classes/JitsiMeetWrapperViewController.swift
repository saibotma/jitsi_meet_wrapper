import UIKit
import JitsiMeetSDK

// This is closely inspired by:
// https://github.com/jitsi/jitsi-meet-sdk-samples/blob/18c35f7625b38233579ff34f761f4c126ba7e03a/ios/swift-pip/JitsiSDKTest/src/ViewController.swift
class JitsiMeetWrapperViewController: UIViewController {
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var jitsiMeetView: UIView?

    let options: JitsiMeetConferenceOptions

    // https://stackoverflow.com/a/55208383/6172447
    init(options: JitsiMeetConferenceOptions) {
        self.options = options;
        // Need to pass in nibName and bundle otherwise an error occurs.
        super.init(nibName: nil, bundle: nil)
    }

    // https://stackoverflow.com/a/55208383/6172447
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        openJitsiMeet();
    }
    
    func openJitsiMeet() {
        cleanUp()
        
        let sourceJitsiMeetView = JitsiMeetView()
        // Need to wrap the jitsi view in another view that absorbs all the pointer events
        // because of a flutter bug: https://github.com/flutter/flutter/issues/14720
        let jitsiMeetView = AbsorbPointersView()
        self.jitsiMeetView = jitsiMeetView
        
        jitsiMeetView.addSubview(sourceJitsiMeetView)

        // Make the jitsi view redraw when orientation changes.
        // From: https://stackoverflow.com/a/45860445/6172447
        sourceJitsiMeetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        jitsiMeetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        sourceJitsiMeetView.delegate = self
        sourceJitsiMeetView.join(options)

        // Pip only works inside the app and not OS wide at the moment:
        // https://github.com/jitsi/jitsi-meet/issues/3515#issuecomment-427846699
        //
        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
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
    }
}

extension JitsiMeetWrapperViewController: JitsiMeetViewDelegate {
    func conferenceTerminated(_ data: [AnyHashable: Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.hide { _ in
                self.cleanUp()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func enterPicture(inPicture data: [AnyHashable: Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
}

// This is based on https://github.com/flutter/flutter/issues/35784#issuecomment-516274701.
class AbsorbPointersView : UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
