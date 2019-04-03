//
//  CustomButton.swift
//  ZModalVC_Example
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol CustomViewDelegate: class {
    func customViewDidTap(customView: CustomView)
}

final class CustomView: UIView {
    
    @IBOutlet internal weak var cornerView: UIView!
    internal var cornerRadius: CGFloat = 10.0
    weak var customViewDelegate: CustomViewDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 6.0
        cornerView.layer.masksToBounds = true
        cornerView.layer.cornerRadius = cornerRadius
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButtonDown()
        super.touchesBegan(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButtonUp()
        super.touchesCancelled(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButtonUp()
        super.touchesEnded(touches, with: event)
    }

    @objc internal func viewDidTap() {
        customViewDelegate?.customViewDidTap(customView: self)
    }
}

class CustomButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 6.0
        layer.cornerRadius = frame.height / 2
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButtonDown()
        super.touchesBegan(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButtonUp()
        super.touchesCancelled(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateButtonUp()
        super.touchesEnded(touches, with: event)
    }
}

extension UIView {
    func animateButtonDown() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: nil)
    }

    func animateButtonUp(completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

