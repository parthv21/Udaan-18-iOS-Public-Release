//
//  SideNavVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import StoreKit

class SideNavVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sideNavTableView: UITableView!
    @IBOutlet weak var dismissSideNavBtn: UIButton!
    
    @IBOutlet weak var sideNavContainer: UIView!
    
    
    
    let NAV_TRANSITION_DURATION = 0.30
    let items = ["Committee","Sponsors","Facebook","Instagram","Website","About"]
    let icon = [#imageLiteral(resourceName: "Committee"),#imageLiteral(resourceName: "Sponsor"),#imageLiteral(resourceName: "fb"),#imageLiteral(resourceName: "ig"),#imageLiteral(resourceName: "link"),#imageLiteral(resourceName: "about")]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sideNavTableView.dataSource = self
        sideNavTableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        UIView.animate(withDuration: NAV_TRANSITION_DURATION, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40)
            //self.sideNavTableView.transform = CGAffineTransform(translationX: -200, y: 0)
            //self.dismissSideNavBtn.transform = CGAffineTransform(translationX: -200, y: 0)
            self.sideNavContainer.transform = CGAffineTransform(translationX: -200, y: 0)

        })
    }
  
    
    @IBAction func dismissSideNavTapped(_ sender: Any) {
        hideNav()
    }
  
    func hideNav() {
        
        UIView.animate(withDuration: NAV_TRANSITION_DURATION, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
            //self.sideNavTableView.transform = CGAffineTransform(translationX: 200, y: 0)
            //self.dismissSideNavBtn.transform = CGAffineTransform(translationX: 200, y: 0)
            self.sideNavContainer.transform = CGAffineTransform(translationX: 200, y: 0)
        }) { (state) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideNavCell") as? SideNavCell else { print("Error");return UITableViewCell() }
    
        cell.configureCell(iconImage: icon[indexPath.row], titleText: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row == 0 {
            
            performSegue(withIdentifier: "ShowCommittee", sender: nil)
            
        } else if indexPath.row == 1 {
            
            
            performSegue(withIdentifier: "ShowSponsors", sender: nil)
            
        } else if indexPath.row == 2 {
            
            let facebookHook = "fb://profile/738555199492741"
            let facebookUrl = "https://www.facebook.com/UdaanCultFest/"
            
            redirectToApp(urlString: facebookHook, fallbackUrl: facebookUrl)
            
        } else if indexPath.row == 3 {
            
            let instagramHooks = "instagram://user?username=udaan2018"
            let instagramUrl = "https://www.instagram.com/udaan2018"
            
            redirectToApp(urlString: instagramHooks, fallbackUrl: instagramUrl)
            
        } else if indexPath.row == 4 {
            
            if let URL = URL(string: "http://udaanthefest.com") {
                
                redirectToURL(url: URL)
            }
        }else if indexPath.row == 5 {
            
            performSegue(withIdentifier: "ShowAbout", sender: nil)
        }
    }
    
    func redirectToURL(url: URL) {
       
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    func redirectToApp(urlString: String,fallbackUrl: String) {
        
        if let url = URL(string: urlString) {
        
            if UIApplication.shared.canOpenURL(url) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                    
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
                
                } else {
                
                guard let url = URL(string: fallbackUrl) else {
                    return
                }
                redirectToURL(url: url)
            }
        }
        
    }
    
    
    @IBAction func rateAppTapped(_ sender: Any) {
        print("RATE APP TAPPED")
        var NO_OF_REVIEW_REQUESTS = defaults.object(forKey: "reviewCount") as? Int
        
        if NO_OF_REVIEW_REQUESTS == nil {
            print("NO_OF_REVIEW_REQUESTS not set")
            defaults.set(1, forKey: "reviewCount")
            NO_OF_REVIEW_REQUESTS = 0
            
        } else {
            
            if let reviewCount = NO_OF_REVIEW_REQUESTS {
                defaults.set(reviewCount + 1, forKey: "reviewCount")
            }
            
        }
        
        if #available(iOS 10.3, *) {
            
            if NO_OF_REVIEW_REQUESTS! < 3 {
                print("REVIEW REQUESTS: ",NO_OF_REVIEW_REQUESTS)
                SKStoreReviewController.requestReview()
                
            } else {
               
                print("iOS 11 redirecting to appstore for review.")
                askReviewWithUrl()
                
            }
            
        } else  {
            
            
            askReviewWithUrl()
        }
    }
    
    
    func askReviewWithUrl() {
        print("Will redirect to app store.")
        if let redirectUrl = URL(string: appStoreUrl) {
            print("URL IS:",redirectUrl)
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(redirectUrl, options: [:], completionHandler: nil)
                
            } else {
                
                UIApplication.shared.openURL(redirectUrl)
            }
        }
    }
    
    
    @IBAction func dismissNavGesture(_ sender: Any) {
        
        hideNav()
    }
    
}
