import UIKit
import JitsiMeetSDK

public typealias AnimationCompletion = (Bool) -> Void

// A custom implementation is required atm.
// See https://github.com/jitsi/jitsi-meet/pull/10475 for more information.
public protocol CustomPiPViewCoordinatorDelegate: AnyObject {

    func exitPictureInPicture()
}

/// Coordinates the view state of a specified view to allow
/// to be presented in full screen or in a custom Picture in Picture mode.
/// This object will also provide the drag and tap interactions of the view
/// when is presented in Picture in Picture mode.
public class CustomPiPViewCoordinator {

    public enum Position {
        case lowerRightCorner
        case upperRightCorner
        case lowerLeftCorner
        case upperLeftCorner
    }

    /// Limits the boundaries of view position on screen when minimized
    public var dragBoundInsets: UIEdgeInsets = UIEdgeInsets(top: 25,
            left: 5,
            bottom: 5,
            right: 5) {
        didSet {
            dragController.insets = dragBoundInsets
        }
    }

    private let initialPositionInSuperView: CustomPiPViewCoordinator.Position = .lowerRightCorner

    // Unused. Remove on the next major release.
    @available(*, deprecated, message: "The PiP window size is now fixed to 150px.")
    public var c: CGFloat = 0.0

    public weak var delegate: CustomPiPViewCoordinatorDelegate?

    private(set) var isInPiP: Bool = false // true if view is in PiP mode
    private(set) var view: UIView
    private var currentBounds: CGRect = CGRect.zero

    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var exitPiPButton: UIButton?

    private let dragController: CustomDragGestureController = CustomDragGestureController()

    public init(withView view: UIView) {
        self.view = view
        // Required because otherwise the view will not rotate correctly.
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    /// Configure the view to be always on top of all the contents
    /// of the provided parent view.
    /// If a parentView is not provided it will try to use the main window
    public func configureAsStickyView(withParentView parentView: UIView? = nil) {
        guard
                let parentView = parentView ?? UIApplication.shared.keyWindow
                else {
            return
        }

        parentView.addSubview(view)
        currentBounds = parentView.bounds
        view.frame = currentBounds
        view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        // Otherwise the enter/exit pip animation looks odd
        // when pip window is bottom left, top left or top right,
        // because the jitsi view content does not animate, but jumps to the new size immediately.
        view.clipsToBounds = true
    }

    /// Show view with fade in animation
    public func show(completion: AnimationCompletion? = nil) {
        if view.isHidden || view.alpha < 1 {
            view.isHidden = false
            view.alpha = 0

            animateTransition(animations: { [weak self] in
                self?.view.alpha = 1
            }, completion: completion)
        }
    }

    /// Hide view with fade out animation
    public func hide(completion: AnimationCompletion? = nil) {
        if view.isHidden || view.alpha > 0 {
            animateTransition(animations: { [weak self] in
                self?.view.alpha = 0
                self?.view.isHidden = true
            }, completion: completion)
        }
    }

    /// Resize view to and change state to custom PictureInPicture mode
    /// This will resize view, add a  gesture to enable user to "drag" view
    /// around screen, and add a button of top of the view to be able to exit mode
    public func enterPictureInPicture() {
        isInPiP = true
        // Resizing is done by hand when in pip.
        view.autoresizingMask = []

        animateViewChange()
        dragController.startDragListener(inView: view)
        dragController.insets = dragBoundInsets

        // add single tap gesture recognition for displaying exit PiP UI
        let exitSelector = #selector(toggleExitPiP)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                action: exitSelector)
        self.tapGestureRecognizer = tapGestureRecognizer
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    /// Exit Picture in picture mode, this will resize view, remove
    /// exit pip button, and disable the drag gesture
    @objc public func exitPictureInPicture() {
        isInPiP = false
        // Enable autoresizing again, which got disabled for pip.
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        animateViewChange()
        dragController.stopDragListener()

        // hide PiP UI
        exitPiPButton?.removeFromSuperview()
        exitPiPButton = nil

        // remove gesture
        let exitSelector = #selector(toggleExitPiP)
        tapGestureRecognizer?.removeTarget(self, action: exitSelector)
        tapGestureRecognizer = nil

        delegate?.exitPictureInPicture()
    }

    /// Reset view to provide bounds, use this method on rotation or
    /// screen size changes
    public func resetBounds(bounds: CGRect) {
        currentBounds = bounds

        // Is required because otherwise the pip window is buggy when rotating the device.
        // When not in pip then autoresize will do the job.
        if (isInPiP) {
            view.frame = changeViewRect()
        }
    }

    /// Stop the dragging gesture of the root view
    public func stopDragGesture() {
        dragController.stopDragListener()
    }

    /// Customize the presentation of exit pip button
    open func configureExitPiPButton(target: Any,
                                     action: Selector) -> UIButton {
        let buttonImage = UIImage.init(named: "image-resize",
                // Need to get image from original coordinator code.
                in: Bundle(for: PiPViewCoordinator.self),
                compatibleWith: nil)
        let button = UIButton(type: .custom)
        let size: CGSize = CGSize(width: 44, height: 44)
        button.setImage(buttonImage, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = size.width / 2
        button.frame = CGRect(origin: CGPoint.zero, size: size)
        button.center = view.convert(view.center, from: view.superview)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Interactions
    @objc private func toggleExitPiP() {
        if exitPiPButton == nil {
            // show button
            let exitSelector = #selector(exitPictureInPicture)
            let button = configureExitPiPButton(
                    target: self,
                    action: exitSelector
            )
            view.addSubview(button)
            exitPiPButton = button

        } else {
            // hide button
            exitPiPButton?.removeFromSuperview()
            exitPiPButton = nil
        }
    }

    func animateViewChange() {
        UIView.animate(withDuration: 0.25) {
            self.view.frame = self.changeViewRect()
        }
    }

    private func changeViewRect() -> CGRect {
        let bounds = currentBounds

        if !isInPiP {
            return bounds
        }

        // resize to suggested ratio and position to the bottom right
        let adjustedBounds = bounds.inset(by: dragBoundInsets)
        let size = CGSize(width: 150, height: 150)
        let origin = getOriginFor(
                position: dragController.currentPosition ?? initialPositionInSuperView,
                inBounds: adjustedBounds,
                withSize: size
        )
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }

    // MARK: - Animation helpers
    private func animateTransition(animations: @escaping () -> Void,
                                   completion: AnimationCompletion?) {
        UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: .beginFromCurrentState,
                animations: animations,
                completion: completion
        )
    }

}

func getOriginFor(position: CustomPiPViewCoordinator.Position, inBounds bounds: CGRect, withSize size: CGSize) -> CGPoint {
    switch position {
    case .lowerLeftCorner:
        return CGPoint(x: bounds.minX, y: bounds.maxY - size.height)
    case .lowerRightCorner:
        return CGPoint(x: bounds.maxX - size.width, y: bounds.maxY - size.height)
    case .upperLeftCorner:
        return CGPoint(x: bounds.minX, y: bounds.minY)
    case .upperRightCorner:
        return CGPoint(x: bounds.maxX - size.width, y: bounds.minY)
    }
}
