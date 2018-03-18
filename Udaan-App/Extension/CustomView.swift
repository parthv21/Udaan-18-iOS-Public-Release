//
//  CustomView.swift
//  Udaan-App
//
//  Created by Parth Tamane on 29/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        
        gradientLayer.colors = [UIColor(red:0.42, green:0.91, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.12, green:0.86, blue:1.00, alpha:1.0).cgColor,UIColor(red:0.09, green:0.69, blue:0.80, alpha:1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        //gradientLayer.locations = [0.5,1]
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}
