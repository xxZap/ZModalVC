//
//  SimpleTableViewCell.swift
//  ZModalVC_Example
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/// A very simple table view cell with an imageview on the left and a label
class SimpleTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Life-cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor(red: 105.0/255.0, green: 75.0/255.0, blue: 101.0/255.0, alpha: 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }

    // MARK: - Public methods
    public func configure(withText text: String?) {
        self.titleLabel.text = text
        self.setNeedsLayout()
    }
}
