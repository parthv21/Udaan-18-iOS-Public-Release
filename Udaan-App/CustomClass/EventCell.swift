//
//  EventCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 27/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase

class EventCell: UITableViewCell{
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var cost: UILabel!
  
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var prize: UILabel!
    
    @IBOutlet weak var register: UIButton!
    
    @IBOutlet weak var eventDetailsContainer: UIStackView!
    
    @IBOutlet weak var callOrganizerBtn: UIButton!
    
    @IBOutlet weak var callBackupOrganizerBtn: UIButton!
    
    //@IBOutlet weak var organizer: UILabel!
    
    @IBOutlet weak var posterWidth: NSLayoutConstraint!
    
    @IBOutlet weak var contactDetailsStackView: UIStackView!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activityIndicatorContainer: UIView!
    
    var delegate: TriggerSegue!
    var eventNumber: String?
    var categoryNumber: String?
    
    var registerRef: DatabaseReference!
    var eventRegistrationsRef: DatabaseReference!
    
    var mainOrganizerName: String!
    var mainContactNumber: String!
    
    var backupOrganizerName: String!
    var backupContactNumber: String!
    
    func configureCell(eventDetails: EventDetails ) {
        
        self.name.text = eventDetails.name
        self.room.text = eventDetails.room
        
        if let intCost = Int(eventDetails.cost) {
            self.cost.text = "₹ \(intCost)"
        } else {
            self.cost.text = eventDetails.cost
        }
        
        desc.text = eventDetails.desc
        mainContactNumber = eventDetails.contactNumber
        mainOrganizerName = eventDetails.organizer
        
        backupContactNumber = eventDetails.contactNumber2
        backupOrganizerName = eventDetails.organizer2
        
        callOrganizerBtn.setTitle("📞 \(mainOrganizerName ?? "")" ,for: .normal)
        callBackupOrganizerBtn.setTitle("📞 \(backupOrganizerName ?? "")" ,for: .normal)

        prize.text = eventDetails.prize
        date.text = eventDetails.date
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        activityIndicatorContainer.isHidden = true
        
    
        categoryNumber = eventDetails.categoryID
        eventNumber = eventDetails.eventID
        
        register.layer.cornerRadius = 5
        callOrganizerBtn.layer.cornerRadius = 5
        
        poster.layer.cornerRadius = 10
       
        registerRef = currentUser.child("Regestrations").child("cat-"+categoryNumber!).child("eve-"+eventNumber!)
        
        eventRegistrationsRef = databaseRoot.child("Events").child("Regestrations").child("cat-"+categoryNumber!).child("eve-"+eventNumber!).child((Auth.auth().currentUser?.uid)!)
        
        
        registerRef.observeSingleEvent(of: .value) { (snapshot) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                if snapshot.exists() {
                    
                    self.updateRegisterBtn(register: true)
                    
                } else {
                    
                    self.updateRegisterBtn(register: false)
                }
            })
        }
        
        if let cachedPoster = eventPosterCache[eventDetails.name] {
            
            print("\(eventDetails.name)'s poster has been cached.(Event Cell)\n")
            poster.image = cachedPoster
        
        } else {
            
            print("\(eventDetails.name)'s poster has not been cached yet.(Event Cell)\n")
            if let URL = URL(string: eventDetails.posterUrl) {
                
                activityIndicator.isHidden = false
                activityIndicatorContainer.isHidden = false
                activityIndicator.startAnimating()
                
                URLSession.shared.dataTask(with: URL ) { (data, response, error) in
                    
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        let poster = UIImage(data: data)
                        self.poster.image = poster
                        eventPosterCache[eventDetails.name] = poster
                        self.activityIndicator.stopAnimating()
                        self.activityIndicatorContainer.isHidden = true
                        
                    }
                    }.resume()
            }
        }
        
    }
    
    func setContactsStackAxis(setHorizontal horizontal: Bool) {
        
        if horizontal {
            
            contactDetailsStackView.axis = .horizontal
            
            posterWidth.constant = largeScreenEventThumbnailWidth
            
        } else {
            
            contactDetailsStackView.axis = .vertical
            
            posterWidth.constant = smallScreenEventThumbnailWidth
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        let zoomGesture = UITapGestureRecognizer(target: self, action: #selector(zoomImage))
        zoomGesture.numberOfTapsRequired = 1
        poster.addGestureRecognizer(zoomGesture)
        poster.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func zoomImage() {
        
        if delegate != nil, let poster = poster.image {
            
            let posterData = PosterData(poster: poster, contactName: mainOrganizerName , contactNumber: mainContactNumber , backupContactName: backupOrganizerName, backupContactNumber: backupContactNumber )
            
            delegate.performSegue(posterData: posterData)
            
        }
    }
    
    //IBAction
   
    @IBAction func callOrganizerTaooed(_ sender: UIButton) {
        
        let number = mainContactNumber ?? ""
        
        callNumber(number: number)
    }
    
    @IBAction func callBackupOrganizerTapped(_ sender: UIButton) {
        
        let number = backupContactNumber ?? ""
        
        callNumber(number: number)
    }
    
    
    func callNumber(number: String) {
        
        print("Trying to call: ",number)
        
        guard let phoneURL = URL(string: "tel://" + number) else { return }
    
        if UIApplication.shared.canOpenURL(phoneURL) {
    
        if #available(iOS 10.0, *) {
        UIApplication.shared.open(phoneURL)
    
        } else {
        // Fallback on earlier versions
        UIApplication.shared.openURL(phoneURL)
        }
    
    }
    
    }
    
    @IBAction func registerUser(_ sender: Any) {
        
        print("Will register for: ",name.text ?? "")

        registerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                print("Can't reregister")
                
            } else {
                
                self.registerRef.setValue(true)
                
                currentUser.child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        
                        self.eventRegistrationsRef.child("name").setValue(snapshot.value)
                
                    }
                })
                
                //self.register.setTitle("Registered", for: .normal)
                self.updateRegisterBtn(register: true)
            }
        })
    }
    
    func updateRegisterBtn(register: Bool ) {
        
        UIView.animate(withDuration: 0.3) {
            
            if register {
                self.register.setTitle("Registered", for: .normal)
                self.register.backgroundColor = UIColor(red:0.77, green:0.77, blue:0.77, alpha:1.0)
                
            } else {
                
                self.register.setTitle("Register", for: .normal)
                self.register.backgroundColor = UIColor(red:0.06, green:0.42, blue:0.50, alpha:0.50)
            }
        }
        
        
        
    }

}
