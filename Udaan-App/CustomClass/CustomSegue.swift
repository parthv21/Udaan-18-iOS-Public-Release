//
//  CustomSegue.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 10000,
                                   delay: 100.0,
                                   options: [.curveEaseInOut],
                                   animations: {
                                    dst.view.transform = CGAffineTransform(translationX: 1000, y: 0)
        },
                                   completion: { finished in
                                    src.present(dst, animated: false, completion: nil)
        }
        )
    }
}
