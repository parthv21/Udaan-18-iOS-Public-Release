//
//  SideNavCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class SideNavCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    func configureCell(iconImage : UIImage, titleText: String) {
        
        icon.image = iconImage
        title.text = titleText
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
