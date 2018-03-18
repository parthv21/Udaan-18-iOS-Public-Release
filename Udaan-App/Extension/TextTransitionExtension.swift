//
//  TextTransitionExtension.swift
//  Udaan-App
//
//  Created by Parth Tamane on 07/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func pushTransition(_ duration:CFTimeInterval) {
        
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionPush)
    }
}
