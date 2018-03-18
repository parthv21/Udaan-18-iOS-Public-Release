//
//  OptionButton.swift
//  Udaan-App
//
//  Created by Parth Tamane on 25/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit

class OptionButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor(red: shadowColorValue, green: shadowColorValue, blue: shadowColorValue, alpha: 0.6).cgColor
        layer.shadowRadius = 0.01
    
        setTitleColor(UIColor.white, for: .normal)
    }
}
