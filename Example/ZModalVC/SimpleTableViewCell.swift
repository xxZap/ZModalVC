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
        titleLabel.textColor = #colorLiteral(red: 0.1072319878, green: 0.1528862847, blue: 0.08764648438, alpha: 1)
        iconImageView.tintColor = titleLabel.textColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
    }

    // MARK: - Public methods
    public func configure(withText text: String?, andIcon icon: UIImage) {
        self.titleLabel.text = text
        self.iconImageView.image = icon
        self.setNeedsLayout()
    }
}
