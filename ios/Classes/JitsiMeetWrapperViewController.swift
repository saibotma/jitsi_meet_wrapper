import UIKit
import JitsiMeetSDK

class JitsiMeetWrapperViewController: UIViewController {
    @IBOutlet weak var videoButton: UIButton?

    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    fileprivate var jitsiMeetView: JitsiMeetView?

    var roomName: String? = nil
    var serverUrl: URL? = nil
    var subject: String? = nil
    var audioOnly: Bool? = false
    var audioMuted: Bool? = false
    var videoMuted: Bool? = false
    var token: String? = nil
    var featureFlags: Dictionary<String, Any>? = Dictionary();
    var jistiMeetUserInfo = JitsiMeetUserInfo()

    // TODO(saibotma): Remove this?
    @objc func openButtonClicked(sender: UIButton) {
        //openJitsiMeetWithOptions();
    }

    // TODO(saibotma): What is this used for?
    @objc func closeButtonClicked(sender: UIButton) {
        cleanUp();
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        view.backgroundColor = .black
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        openJitsiMeet();
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        pipViewCoordinator?.resetBounds(bounds: rect)
    }

    func openJitsiMeet() {
        cleanUp()

        let jitsiMeetView = JitsiMeetView()

        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            // TODO(saibotma): Why is this true and not set by flutter?
            builder.welcomePageEnabled = true
            builder.room = self.roomName
            builder.serverURL = self.serverUrl
            builder.setSubject(self.subject ?? "")
            // TODO(saibotma): Fix typo
            builder.userInfo = self.jistiMeetUserInfo
            builder.setAudioOnly(self.audioOnly ?? false)
            builder.setAudioMuted(self.audioMuted ?? false)
            builder.setVideoMuted(self.videoMuted ?? false)
            builder.token = self.token

            self.featureFlags?.forEach { key, value in
                builder.setFeatureFlag(key, withValue: value);
            }
        }

        jitsiMeetView.join(options)

        // Enable jitsimeet view to be a view that can be displayed
        // on top of all the things, and let the coordinator to manage
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: view)

        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }

    func closeJitsiMeeting() {
        jitsiMeetView?.leave()
    }

    fileprivate func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
        // TODO(saibotma): Remove?
        //self.dismiss(animated: true, completion: nil)
    }
}
