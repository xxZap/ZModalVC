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
        "Account",
        "Chats",
        "Data and Usage",
        "Notifications",
        "Help Center",
        "Terms and Service",
        "Logout"
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
            cell.separatorInset = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 ?
                UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0) :
                UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.isSelected = false
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ModalChildExampleTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
