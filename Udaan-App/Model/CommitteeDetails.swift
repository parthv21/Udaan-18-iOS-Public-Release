//
//  CommitteeDetails.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import Foundation
import UIKit

class CommitteeMember {
    
    var name: String
    var emoji: String
    var rank: String
    var position: String
    var quote: String
    var avatar: UIImage
    
    init (name: String, emoji: String, rank: String, position: String, quote: String, avatar: UIImage) {
        
        self.name = name
        self.emoji = emoji
        self.rank = rank
        self.position = position
        self.quote = quote
        self.avatar = avatar

    }
}
