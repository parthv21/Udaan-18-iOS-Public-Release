//
//  EventListVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 26/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class EventListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,TriggerSegue, UIScrollViewDelegate {

    @IBOutlet weak var categoryBanner: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var eventsCount: UILabel!
    
    @IBOutlet weak var eventList: UITableView!
    
    @IBOutlet weak var dismissEventBtn: UIButton!
    
    @IBOutlet weak var bannerAdContainer: GADBannerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let ref = Database.database().reference()
    var events = Dictionary<Int,Any>()
    
    var categoryIndex = 0
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventList.dataSource = self
        eventList.delegate = self
        
        dismissEventBtn.layer.cornerRadius = dismissEventBtn.bounds.width / 2
        dismissEventBtn.layer.masksToBounds = true
        
        setRefreshController()
        
        //MARK: - Banner Ad Config
        bannerAdContainer.adUnitID = eventListBannerUnitId
        bannerAdContainer.rootViewController = self
        bannerAdContainer.load(GADRequest())
        
        fetchEvents { (events) in
            
            self.events = events
            self.eventList.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        categoryBanner.image = categoriesBG[categoryIndex]
        
    }
    
    func performSegue(posterData: PosterData) {
        
        performSegue(withIdentifier: "ShowZoomedImage", sender: posterData)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if "ShowZoomedImage" == segue.identifier {
            
            if let destination = segue.destination as? FullImageVC, let posterData = sender as? PosterData {
                
                destination.passedPoster = posterData.poster
                destination.contactName = posterData.contactName
                destination.contactNumber = posterData.contactNumber
                destination.backupContactName = posterData.backupContactName
                destination.backupContactNumber = posterData.backupContactNumber
                
                destination.showCallBtn = true
            }
        }
    }
    
    
    func fetchEvents(completed:@escaping (Dictionary<Int,Any>)->()) {
        
        var events  = Dictionary<Int,Any>()
        
            fullEventsRef.child(String(categoryIndex)).observe(.value, with: {
            (snapshot) in
                
            if let value = snapshot.value as? NSArray {
                
                if value.count > 0 {
                    
                    self.categoryName.text = value[0] as! String
                    
                    self.eventsCount.text = "\(value.count - 1) events"
                    
                    for (index,value) in value.enumerated() {
                        
                        if index != 0 {
                            
                            if let event = value as? Dictionary<String,Any> {
                                
                                events[index - 1] = event
                                
                            }
                        }
                    }
                }
            }
            completed(events)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if isSmallScreen {
            
            return 370
            
        } else {
            
            return 340
        
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let event = events[indexPath.row] as? Dictionary<String,Any> {
            
            let eventDetails = EventDetails(event: event)
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell {
                
                cell.configureCell(eventDetails: eventDetails)
                
                cell.delegate = self
                
                return cell
                
            }
        }
        
        return UITableViewCell()
    }
    
    

    func setRefreshController() {
        
        refreshControl = UIRefreshControl()
       
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "ChalkboardSE-Regular", size: 25) ]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Let go to dismiss!", attributes: attributes)
        
        refreshControl.tintColor = .clear
        
        refreshControl.backgroundColor = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0)
        
        if #available(iOS 10, *) {
            eventList.refreshControl = refreshControl
        } else {
            eventList.addSubview(refreshControl)
        }
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y > -80 {
            refreshControl.endRefreshing()
        } else {
           
           eventList.setContentOffset( scrollView.contentOffset, animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.alpha = 0
                
            }, completion: { (state) in
                print("State is: ",state)
                
                self.dismiss(animated: true)
                
            })
        }
        
    }
    //IBAction
    @IBAction func dismissEvents(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
