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
    @IBOutlet internal weak var firstButton: UIButton!
    @IBOutlet internal weak var secondButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func firstButtonDidTap(_ sender: UIButton) {
        openExample()
    }

    @IBAction func secondButtonDidTap(_ sender: UIButton) {
        openTableExample()
    }
}

// MARK: - Private functions
extension ViewController {
    internal func setupUI() {
        firstButton.layer.cornerRadius = 5
        firstButton.setTitleColor(UIColor(red: 47.0/255.0, green: 72.0/255.0, blue: 88.0/255.0, alpha: 1), for: .normal)
        secondButton.layer.cornerRadius = 5
        secondButton.setTitleColor(UIColor(red: 47.0/255.0, green: 72.0/255.0, blue: 88.0/255.0, alpha: 1), for: .normal)
    }

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

