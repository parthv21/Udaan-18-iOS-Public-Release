//
//  SponsorTitleCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 13/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class SponsorTitleCell: UICollectionReusableView {
    
    @IBOutlet weak var title: UILabel!
    
    func configureCell(title: String) {
        
        self.title.text = title
    }
    
}
