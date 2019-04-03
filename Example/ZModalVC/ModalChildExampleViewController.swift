//
//  ModalChildExampleViewController.swift
//  ModalVC_Example
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ZModalVC

class ModalChildExampleViewController: ZModalChildViewController {
    // MARK: - Outlets
    @IBOutlet internal weak var headerView: UIView!
    @IBOutlet internal weak var photo: UIImageView!
    @IBOutlet internal weak var bodyView: UIView!
    @IBOutlet internal weak var constraintBetweenHeaderTopAndSafeAreaBottom: NSLayoutConstraint!

    // MARK: - ZModalChildViewController
    override func getBackgroundColor() -> UIColor? {
        return UIColor.white
    }

    override func getHeight() -> CGFloat {
        return constraintBetweenHeaderTopAndSafeAreaBottom.constant
    }

    // MARK: - Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.layer.masksToBounds = true
        photo.layer.shadowColor = UIColor(red: 47.0/255.0, green: 72.0/255.0, blue: 88.0/255.0, alpha: 1).cgColor
        photo.layer.shadowOffset = CGSize.zero
        photo.layer.shadowOpacity = 0.15
        photo.layer.shadowRadius = 8
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.z_roundCorners([.bottomLeft, .bottomRight], radius: 7)
        bodyView.z_roundCorners([.topLeft, .topRight], radius: 7)
    }

}
