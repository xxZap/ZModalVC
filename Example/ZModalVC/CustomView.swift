//
//  CustomButton.swift
//  ZModalVC_Example
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

final class CustomButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor

            shadowLayer.shadowColor = UIColor(red: 47.0/255.0, green: 72.0/255.0, blue: 88.0/255.0, alpha: 1).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 5.0)
            shadowLayer.shadowOpacity = 0.25
            shadowLayer.shadowRadius = 10

            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
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

extension UIButton {
    func animateButtonDown() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: nil)
    }

    func animateButtonUp() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
