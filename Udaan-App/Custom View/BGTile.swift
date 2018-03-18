//
//  BGTile.swift
//  Udaan-App
//
//  Created by Parth Tamane on 25/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit

class BGTile: UIImageView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        layer.cornerRadius = 10
    
       
        }
    
    @IBInspectable public var shadowOpacity: Float = 2.2 {
        
        didSet {
            
            layer.shadowOpacity = shadowOpacity
            layer.shadowColor = UIColor(red: shadowColorValue, green: shadowColorValue, blue: shadowColorValue, alpha: 1.0).cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        }
        
    }

}
