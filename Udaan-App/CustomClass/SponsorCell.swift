//
//  SponsorCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 13/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class SponsorCell: UICollectionViewCell {
    
    @IBOutlet weak var sponsorLogo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorContainer: RoundUIView!
    var sponserLink: URL!
    
    
    func configureCell(sponsor: SponsorDetails) {
        
        name.text = sponsor.name
        sponserLink = sponsor.link
        
        //layer.borderColor = UIColor(red:0.92, green:0.75, blue:0.71, alpha:1.0).cgColor
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 5
        clipsToBounds = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicatorContainer.isHidden = false
        
        URLSession.shared.dataTask(with: sponsor.logo) { (data, response, error) in
            
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                
                self.sponsorLogo.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.activityIndicatorContainer.isHidden = true
            }
        }.resume()
        
    }
}
