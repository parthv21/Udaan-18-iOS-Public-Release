//
//  CustomButton.swift
//  Udaan-App
//
//  Created by Parth Tamane on 08/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    
    @IBInspectable public var cornerRadius: CGFloat = 40 {
        
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
   
}
