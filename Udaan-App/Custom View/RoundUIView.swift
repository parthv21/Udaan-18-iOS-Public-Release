//
//  RoundUIView.swift
//  Udaan-App
//
//  Created by Parth Tamane on 25/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class RoundUIView: UIView {

    @IBInspectable public var viewCornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = viewCornerRadius
        }
    }
}
