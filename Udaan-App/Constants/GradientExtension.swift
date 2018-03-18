//
//  UIButtonExtension.swift
//  Udaan-App
//
//  Created by Parth Tamane on 24/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradient(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.6)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
