//
//  savedCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 26/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase

class SavedCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImg: UIImageView!
    
   
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var eventNameHeight: NSLayoutConstraint!
    
    @IBOutlet weak var unregisterBtn: CustomButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activityIndicatorContainer: RoundUIView!
    
    var categoryID = ""
    var eventID = ""
    
    var eventDetails: EventDetails!
    var posterData: PosterData!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1).cgColor
    }
    
    
    
    func configureCell(eventDetails: EventDetails) {
        
        unregisterBtn.isHidden = false
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityIndicatorContainer.isHidden = true
        
        title.text = eventDetails.name
        
        if let cachedPoster = eventPosterCache[eventDetails.name] {
            
            print("\(eventDetails.name)'s poster has been cached.(Saved Cell)\n")
            bgImg.image = cachedPoster
            
            posterData = PosterData(poster: cachedPoster, contactName: eventDetails.organizer, contactNumber: eventDetails.contactNumber, backupContactName: eventDetails.organizer2,backupContactNumber: eventDetails.contactNumber2)
            
        } else {
            
            if let posterURL = URL(string: eventDetails.posterUrl) {
                
                print("\(eventDetails.name)'s poster has not been cached.(Saved Cell)\n")

                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                activityIndicatorContainer.isHidden = false
                
                URLSession.shared.dataTask(with: posterURL) { (data, response, error) in
                    
                    guard let data = data, error == nil else {return }
                    
                    DispatchQueue.main.async {
                        
                        let poster = UIImage(data: data)
                        self.bgImg.image = poster
                        eventPosterCache[eventDetails.name] = poster
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.activityIndicatorContainer.isHidden = true
                        
                        self.posterData = PosterData(poster: poster ?? UIImage(), contactName: eventDetails.organizer, contactNumber: eventDetails.contactNumber, backupContactName: eventDetails.organizer2,backupContactNumber: eventDetails.contactNumber2)
                        
                    }
                    }.resume()
                
            }
            
        }
        
        eventNameHeight.constant = isSmallScreen ? self.bounds.height / 3 : self.bounds.height / 4
        
        categoryID = "cat-\(eventDetails.categoryID)"
        eventID = "eve-\(eventDetails.eventID)"
        
    }
    
    @IBAction func unregisterFromEvent(_ sender: Any) {
        
        print("Will remove: ",categoryID,": ",eventID)
        
        let userId = Auth.auth().currentUser?.uid
       
        eventRegistrationRef.child(categoryID).child(eventID).child(userId!).removeValue()

        userRegestrationRef.child(categoryID).child(eventID).removeValue()
    }
}
