//
//  ZModalChildViewController.swift
//  ZModalVC
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright (c) 2019 Alessio Zap Boerio. All rights reserved.
//

import Foundation
import UIKit

/// A ViewController that must be presented inside an **ZModalViewController**.
open class ZModalChildViewController: UIViewController {
    /// The **ZModalViewController** who this view controller belong to
    public weak var modalParentViewController: ZModalViewController?

    /// The delegate of this ZModalViewController
    public weak var delegate: ZModalDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    /// Returns the current **height** of this **ZModalChildViewController**.
    ///
    /// *Override* it if needed (example: tableview, collectionview or other view controllers with dynamic size)
    open func getHeight() -> CGFloat { return self.view.frame.height }

    /// Returns the color that the `ZModalViewController` will use to paint the extra view in the bottom of the screen.
    open func getBackgroundColor() -> UIColor? { return self.view.backgroundColor }

    /// By default it returns the `getBackgroundColor`
    open func getTopBarColor() -> UIColor? { return getBackgroundColor() }

    /// By default is nil. If different, it will override the color of the line inside the `TopBarView`
    open func getTopLineColor() -> UIColor? { return nil }

    /// If this ViewController has an **ZModalViewController** it will call the parent.dismiss.
    /// Otherwise it will dismiss normally.
    open func dismiss(animated: Bool) {
        if let parent = modalParentViewController {
            parent.dismissPopup()
        } else {
            super.dismiss(animated: animated)
        }
    }

    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let parent = modalParentViewController {
            parent.dismissPopup(animationTime: flag ? 0.5 : 0) {
                completion?()
            }
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}
