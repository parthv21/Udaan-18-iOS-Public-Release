//
//  RoundUILabel.swift
//  Udaan-App
//
//  Created by Parth Tamane on 25/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class RoundUILabel: UILabel {

    @IBInspectable public var labelCornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = labelCornerRadius
            layer.masksToBounds = true
            
        }
    }

}
