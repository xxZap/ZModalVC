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
    // MARK: - ZModalChildViewController overrides
    override func getTopBarColor() -> UIColor? { return UIColor(red: 87.0/255.0, green: 152.0/255.0, blue: 118.0/255.0, alpha: 1) }
    override func getTopLineColor() -> UIColor? { return UIColor.white }
}
