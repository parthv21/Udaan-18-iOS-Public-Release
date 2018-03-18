//
//  PosterData.swift
//  Udaan-App
//
//  Created by Parth Tamane on 26/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

class PosterData {
    
    var poster: UIImage!
    var contactName: String!
    var contactNumber: String!
    
    var backupContactName: String!
    var backupContactNumber: String!
    
    init(poster: UIImage, contactName: String, contactNumber: String, backupContactName: String, backupContactNumber: String ) {
        
        self.poster = poster
        self.contactName = contactName
        self.contactNumber = contactNumber
        self.backupContactName = backupContactName
        self.backupContactNumber = backupContactNumber
        
    }
}
