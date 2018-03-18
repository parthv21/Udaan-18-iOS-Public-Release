//
//  SponsorDetails.swift
//  Udaan-App
//
//  Created by Parth Tamane on 13/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import Foundation

class SponsorDetails {

    var name: String
    var logo: URL
    var link: URL
    
    init (name: String,logo: String,link: String) {
    
        self.name = name
        self.logo = URL(string: logo)!
        self.link = URL(string: link)!
        
    }
}

