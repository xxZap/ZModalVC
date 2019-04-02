//
//  ZModalViewController.swift
//  ZModalVC
//
//  Created by Alessio Zap Boerio on 03/31/2019.
//  Copyright (c) 2019 Alessio Zap Boerio. All rights reserved.
//

import Foundation
import UIKit

public protocol ZModalDelegate: class {
    func ancillaryPopupIsCanceling(popupViewController: ZModalChildViewController)
    func ancillaryPopupHasMadeChanges(popupViewController: ZModalChildViewController)
}

/// This is a View Controller that comes from bottom and has vertical swipe gesture to handle the dismiss (animated).
///
/// Instantiate this through **ZModalChildViewController.instantiate()**.
///
/// It presents another sub-viewcontroller inside its `containerView`.
///
/// Add the desired sub-viewcontroller with **loadViewController()**
open class ZModalViewController: UIViewController {

    // MARK: - IBOutlets
    /// The background of this ViewController. It's alpha will be animated.
    @IBOutlet weak internal var viewBG: UIView!

    /// Useful empty view to calculate the space between the `containerView` and the top of the safe area.
    @IBOutlet weak internal var availableSpaceView: UIView!

    /// A simple view who wraps the `topCornerView` and has pan gesture to move the `containerView` vertically.
    @IBOutlet weak internal var draggableView: UIView!

    /// A simple view between `containerView` and `availableSpaceView` with rounded corners.
    @IBOutlet weak internal var topCornerView: UIView!

    /// A simple view anchored to the bottom of the `containerView` that becomes visible once the user swipe up.
    @IBOutlet weak internal var outOfScreenView: UIView!

    /// This is the scrollview that contains the `containerView`.
    @IBOutlet weak internal var scrollContainerView: UIScrollView!

    /// This is the container view that contains the `subViewController`.
    @IBOutlet weak internal var containerView: UIView!

    /// This constraint allows this view controller to move the containerView vertically.
    @IBOutlet weak internal var constraintFromBottom: NSLayoutConstraint!

    /// The height of the `containerView`.
    @IBOutlet weak internal var containerViewHeightConstraint: NSLayoutConstraint!

    /// The height of the `scrollContainerView`.
    @IBOutlet weak internal var scrollContainerViewHeightConstraint: NSLayoutConstraint!

    /// The line view to give a feedback to the user that the view is draggable.
    @IBOutlet weak internal var handleView: UIView!

    /// The ViewController that is contained by `containerView`.
    private(set) weak var subViewController: ZModalChildViewController?

    // drag gesture stuff
    internal var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    internal var animationTime = 0.5
    internal var backgroundMaxOpacity: CGFloat = 0.66
    internal var viewIsDragging: Bool = false
    internal var draggableViewPanGesture: UIPanGestureRecognizer?
    internal var scrollViewPanGesture: UIPanGestureRecognizer?

    /// is the maximum height that will be used to calculate the return-bounce or the dismissable-distance.
    internal var maxContainerHeight: CGFloat {
        get {
            return min(scrollContainerViewHeightConstraint.constant, UIScreen.main.bounds.height - 100)
        }
        set {
            scrollContainerViewHeightConstraint.constant = min(newValue, UIScreen.main.bounds.height - 100)
        }
    }

    /// a flag used to know if the from-bottom-to-top animation should be launced or not.
    /// by defult it becomes false after the first viewDidAppear()
    internal var isFirstAppearance: Bool = true

    // MARK: - Life Cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadViewController(nil)
    }

    deinit {
        print("\(self.description): Deinit")
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstAppearance {
            topCornerView.setNeedsLayout()
            topCornerView.layoutIfNeeded()
            topCornerView.z_roundCorners([.topLeft, .topRight], radius: 10)
        }

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: -topCornerView.frame.height)
        containerView.layer.shadowRadius = 10

        handleView.layer.cornerRadius = handleView.frame.height / 2
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppearance {
            isFirstAppearance = false
            scrollContainerView.delegate = self
            updateContainer()
            setBottomConstraint(to: maxContainerHeight)
        }
    }

    // MARK: - Setup
    /// Configure and setup colors, localized strings, alpha, constraint, etc...
    internal func setupUI() {
        // graphics
        viewBG.alpha = 0

        // gesture
        draggableViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(draggableViewDidPan(_:)))
        draggableViewPanGesture?.delegate = self
        scrollViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(draggableViewDidPan(_:)))
        scrollViewPanGesture?.delegate = self

        // actions
        draggableView.addGestureRecognizer(draggableViewPanGesture!)
        scrollContainerView.addGestureRecognizer(scrollViewPanGesture!)
        availableSpaceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDidTap(_:))))

        // constraints
        constraintFromBottom.constant = 0

        availableSpaceView.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
    }

    // MARK: - IBActions
    /// The user tapped the `availableSpaceView`
    @objc public func dismissDidTap(_ sender: UITapGestureRecognizer) {
        if !viewIsDragging {
            dismissPopup()
        }
    }

    /// The user is panning
    @objc public func draggableViewDidPan(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)

        if sender.state == UIGestureRecognizer.State.began, !viewIsDragging {
            viewIsDragging = true
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed, sender.numberOfTouches == 1 {
            if scrollContainerView.contentOffset.y == 0 {
                if touchPoint.y - initialTouchPoint.y > 0 {
                    constraintFromBottom.constant =  maxContainerHeight - (touchPoint.y - initialTouchPoint.y)
                    let alfaPan = 1 - ((maxContainerHeight - constraintFromBottom.constant) / maxContainerHeight)
                    viewBG.alpha = alfaPan
                } else {
                    constraintFromBottom.constant =  maxContainerHeight - (touchPoint.y - initialTouchPoint.y) * 0.5
                    self.view.layoutIfNeeded()
                }
            } else {
                initialTouchPoint = touchPoint
            }

        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if sender.numberOfTouches == 0 {
                viewIsDragging = false
                if touchPoint.y - initialTouchPoint.y > 150 {
                    let animationPerc = Double(1 - ((maxContainerHeight - constraintFromBottom.constant) / maxContainerHeight))
                    self.dismissPopup(animationTime: animationTime * animationPerc)
                } else {
                    self.constraintFromBottom.constant = maxContainerHeight
                    UIView.animate(withDuration: animationTime, animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                    })
                }
            }
        }
    }

    // MARK: - Methods
    /// Set the color of the top draggable view.
    public func setTopViewBackgroundColor(toColor color: UIColor) {
        topCornerView.backgroundColor = color
    }

    /// Use this to force a reload of the `subViewController` and adapt the `containerView` to the new height (animated).
    ///
    /// This method will change constraints.
    public func forceReload() {
        updateContainer()
        setBottomConstraint(to: self.maxContainerHeight)
    }

    /// Set constraintBottom as the sum of all visible view heights.
    ///
    /// - Parameter duration: the animation time. If nil, `animationTime` will be used.
    public func expandToFitScreen(withDuration duration: Double? = nil) {
        let availableSpace = getAvailableSpace()
        let newHeight = maxContainerHeight + availableSpace
        setBottomConstraint(to: newHeight, duration: duration)
    }

    /// Returns the space between the top of the current popup view and the height of this view controller.
    /// It's useful to know the max height the popup can extend.
    public func getAvailableSpace() -> CGFloat {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let totalAvailableSpace = availableSpaceView.frame.size.height// + draggableView.frame.size.height
        return totalAvailableSpace
    }

    /// Set the background color of the view anchored to the bottom of the `containerView`.
    /// *Default* is **UIColor.white**
    ///
    /// - Parameter color: the desired color.
    public func setOffScreenColor(_ color: UIColor?) {
        outOfScreenView.backgroundColor = color ?? UIColor.white
    }

    /// Dismiss this view controller.
    public func dismissPopup(animationTime: Double = 0.5, onCompletionBeforeDismiss: (() -> Void)? = nil) {
        self.constraintFromBottom.constant = 0
        UIView.animate(withDuration: animationTime, animations: { [weak self] in
            self?.viewBG.alpha = 0
            self?.containerView.layoutIfNeeded()
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] (_) in onCompletionBeforeDismiss?()
                self?.dismiss(animated: false, completion: nil)
        })
    }

    /// Instantiate a new ViewController inside the `containerView`.
    /// If a view controller already exists, it will be dismissed before instantiate the new one.
    ///
    /// - Parameter newSubViewController: the new sub view controller that we want to put inside the `contentView`.
    public func loadViewController(_ newSubViewController: ZModalChildViewController?) {
        // nice trick to load view hierarchy and avoid nil iBOutlet references
        _ = self.view

        guard let newSubViewController = newSubViewController else { return }

        // remove old childViewController
        if let oldVC = self.children.last {
            oldVC.willMove(toParent: nil)
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParent()
        }

        self.addChild(newSubViewController)
        newSubViewController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: self.containerView.frame.size.width,
            height: self.containerView.frame.size.height)
        self.containerView.addSubview(newSubViewController.view)
        newSubViewController.didMove(toParent: self)

        _ = newSubViewController.view
        self.subViewController = newSubViewController
        self.subViewController?.modalParentViewController = self

        self.setOffScreenColor(newSubViewController.view.backgroundColor)
    }
}

// MARK: - Private functions
extension ZModalViewController {
    /// Comunicate with `subViewController` to get its height and update the height of the `containerView`.
    /// Animated.
    internal func updateContainer() {
        if let subViewController = self.subViewController {
            subViewController.modalParentViewController = self
            let subHeight = subViewController.getHeight()
            self.maxContainerHeight = subHeight
            self.containerViewHeightConstraint.constant = subHeight
            self.outOfScreenView.backgroundColor = subViewController.getBackgroundColor()
            self.topCornerView.backgroundColor = subViewController.getTopBarColor()
            if let lineColor = subViewController.getTopLineColor() { self.handleView.backgroundColor = lineColor }
        } else {
            self.maxContainerHeight = 300
            self.containerViewHeightConstraint.constant = 300
        }
    }

    /// Set the position of the MainView.
    ///
    /// - Parameter value: the desired position.
    internal func setBottomConstraint(to value: CGFloat, animated: Bool = true, alpha: CGFloat = 1, duration: Double? = nil) {
        maxContainerHeight = value
        constraintFromBottom.constant = maxContainerHeight
        if animated {
            UIView.animate(withDuration: duration ?? animationTime) { [weak self] in
                self?.viewBG.alpha = alpha
                self?.view.layoutIfNeeded()
            }
        } else {
            self.viewBG.alpha = alpha
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ZModalViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ZModalViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


public extension UIView {
    /// Apply `radius` rounded corner to the desired corners.
    ///
    /// - Parameters:
    ///   - corners: list of desired corner.
    ///   - radius: radius of the corner in points.
    public func z_roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
