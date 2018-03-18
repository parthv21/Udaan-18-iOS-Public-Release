//
//  BorderExtension.swift
//  Udaan-App
//
//  Created by Parth Tamane on 28/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation
import  UIKit

extension UIView {
    
    func borderBottom (color: UIColor, width: CGFloat) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func borderTop(color: UIColor, width: CGFloat) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: width, width:  self.frame.size.width, height: width)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func borderLeft(color: UIColor, width: CGFloat) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width:  width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func borderRight(color: UIColor, width: CGFloat) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width , y: 0, width: width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
}
