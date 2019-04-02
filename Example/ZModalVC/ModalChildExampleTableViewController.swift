//
//  ModalChildExampleTableViewController.swift
//  ModalVC_Example
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ZModalVC

class ModalChildExampleTableViewController: ZModalChildViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Variables
    internal var availableIcons: [UIImage] = [#imageLiteral(resourceName: "ic_accessibility"), #imageLiteral(resourceName: "ic_text_fields"), #imageLiteral(resourceName: "ic_credit_card"), #imageLiteral(resourceName: "ic_texture"), #imageLiteral(resourceName: "ic_swap_horizontal")]
    internal var availableTexs: [String] = [
        "\nUIViewController with a UITableView that extends ZModalChildViewController. The cells have AutomaticDimension.\n",
        "If you like tuna and tomato sauce- try combining the two. It’s really not as bad as it sounds.",
        "He said he was not there yesterday; however, many people saw him there.",
        "Is it free?",
        "Lets all be unique together until we realise we are all the same.",
        "I really want to go to work, but I am too sick to drive.",
        "They got there early, and they got really good seats.",
        "Sixty-Four comes asking for bread.",
        "My Mum tries to be cool by saying that she likes all the same things that I do.",
        "I am happy to take your donation; any amount will be greatly appreciated.",
        "I will never be this young again. Ever. Oh damn… I just got older.",
        "We have never been to Asia, nor have we visited Africa."
    ]

    var lastVerticalContentOffsetY: CGFloat = 0 {
        didSet { tableView.isScrollEnabled = lastVerticalContentOffsetY != 0 }
    }

    // MARK: - ZModalChildViewController overrides
    override func getHeight() -> CGFloat { return tableView.contentSize.height }

    // MARK: - Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
}

// MARK: - Private functions
extension ModalChildExampleTableViewController {
    internal func setupUI() {
        self.view.backgroundColor = UIColor(red: 248.0/255.0, green: 247.0/255.0, blue: 246.0/255.0, alpha: 1)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    internal func setupTableView() {
        tableView.registerCellNib(SimpleTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor(red: 105.0/255.0, green: 75.0/255.0, blue: 101.0/255.0, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc internal func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            tableView.isScrollEnabled = true
            lastVerticalContentOffsetY = tableView.contentOffset.y
        case .ended, .cancelled:
            self.tableView.isScrollEnabled = true
        default:
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension ModalChildExampleTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.random(in: 3..<availableTexs.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(SimpleTableViewCell.self, indexPath: indexPath) {
            let icon = availableIcons[indexPath.row % availableIcons.count]
            cell.configure(withText: availableTexs[indexPath.row], andIcon: icon)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ModalChildExampleTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ModalChildExampleTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
