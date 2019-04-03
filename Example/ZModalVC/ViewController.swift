//
//  ViewController.swift
//  ZModalVC
//
//  Created by Alessio Zap Boerio on 03/31/2019.
//  Copyright (c) 2019 Alessio Zap Boerio. All rights reserved.
//

import UIKit
import ZModalVC

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet internal weak var cardView: CustomView!
    @IBOutlet internal weak var optionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.customViewDelegate = self
    }

    @IBAction func optionButtonDidTap(_ sender: UIButton) {
        openTableExample()
    }
}

// MARK: - Private functions
extension ViewController {
    internal func openExample() {
        guard let viewController = ZModalViewController.fromNib() else { return }
        let childVC = ModalChildExampleViewController.fromNib()
        viewController.loadViewController(childVC)
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }

    internal func openTableExample() {
        guard let viewController = ZModalViewController.fromNib() else { return }
        let childVC = ModalChildExampleTableViewController.fromNib()
        viewController.loadViewController(childVC)
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
}

// MARK: - CustomViewDelegate
extension ViewController: CustomViewDelegate {
    func customViewDidTap(customView: CustomView) {
        openExample()
    }
}
