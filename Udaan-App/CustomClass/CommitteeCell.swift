//
//  CommitteeCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class CommitteeCell: UICollectionViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var emoji: UILabel!
    
    @IBOutlet weak var position: UILabel!
    
    @IBOutlet weak var quote: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //layer.shadowColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:0.5).cgColor
        //layer.shadowOffset = CGSize(width: 0, height: 5)
        //layer.shadowOpacity = 0.8
        //layer.shadowRadius = 3.0
        
    }
    
    func configureCell(_ member: CommitteeMember) {
        
        name.text = member.name
        emoji.text = member.emoji
        //position.text = member.position
        quote.text = member.quote
        avatar.image = member.avatar
        
        emoji.layer.cornerRadius = 5
        emoji.clipsToBounds = true
        avatar.layer.cornerRadius = 60
        avatar.clipsToBounds = true
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = UIColor(red:0.00, green:0.25, blue:0.50, alpha:0.6).cgColor
        
        
//        if let url = URL(string: member.avatarUrl) {
//
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//                guard let data = data, error == nil else { return }
//
//
//                DispatchQueue.main.async {
//                    self.avatar.image = UIImage(data: data)
//
//                }
//            }.resume()
//        }
    }
    
    
}
