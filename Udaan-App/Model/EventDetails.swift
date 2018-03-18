//
//  EventDetails.swift
//  Udaan-App
//
//  Created by Parth Tamane on 28/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation

class EventDetails {
    
    let name: String
    let cost: String
    let desc: String
    let posterUrl: String
    let contactNumber: String
    let room: String
    let categoryID: String
    let eventID: String
    let organizer: String
    let email: String
    let contactNumber2: String
    let organizer2: String
    let date: String
    let prize: String
    
    init(event: Dictionary<String,Any>) {
        
        self.name = event["name"] as? String ?? "No_Name"
        
        if let val = event["cost"] as? Int {
            
           cost = "\(val)"
            
        } else {
            
            cost = event["cost"] as? String ?? "-"
        }
        
        desc = event["description"] as? String ?? "No Description"
        
        posterUrl = event["poster"] as? String ?? ""
        
        contactNumber = event["contact"] as? String ?? ""
        
        contactNumber2 = event["contact2"] as? String ?? ""
        
        room = event["room"]  as? String ?? ""
        
        categoryID = "\(event["categoryId"] as! Int)"
        
        eventID = "\(event["eventId"] as! Int)"
        
        organizer = event["organizer"] as? String ?? ""
        
        organizer2 = event["organizer2"] as? String ?? ""
        
        email = event["email"] as? String ?? ""
        
        date = event["date"] as? String ?? "NA"
        
        prize = event["prize"] as? String ?? "NA"
        
    }
    
}



