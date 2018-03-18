//
//  RoundButton.swift
//  Udaan-App
//
//  Created by Parth Tamane on 24/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: shadowColorValue, green: shadowColorValue, blue: shadowColorValue, alpha: 0.6).cgColor
        layer.shadowOffset = CGSize(width: 100, height: 100)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        clipsToBounds = true
        
    }

}
