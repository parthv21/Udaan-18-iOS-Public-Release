//
//  SponsorsVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import SwiftyJSON

class SponsorsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    @IBOutlet weak var sponsorCollection: UICollectionView!
    
    @IBOutlet weak var sponsorActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleBanner: UIView!
    
    var sponsorsModified = [Array<SponsorDetails>]()
    
    var sponsorTitle = [String]()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sponsorCollection.delegate = self
        sponsorCollection.dataSource = self
        
        setRefreshController()
        
        titleBanner.addGradient()
        
        let layout = sponsorCollection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        sponsorRef.observe(.value) { (snapshot) in
            
            self.sponsorsModified.removeAll()
            
            if let value = snapshot.value {
                
                let sponsorList = JSON(value)
            
                let sponsors = sponsorList.sorted(by: { (key1, key2) -> Bool in
                    
                    let comp1 = key1.0.components(separatedBy: "-")
                    let comp2 = key2.0.components(separatedBy: "-")
                    
                    guard let ind1 = Int(comp1[0]), let ind2 = Int(comp2[0]) else { return false }
                    return ind1 < ind2
                })
                
                for (key,subJson):(String,JSON) in sponsors {
                    
                    let components = key.components(separatedBy: "-")
                    if components.indices.contains(1) {
                      self.sponsorTitle.append(components[1])
                    }
                    
                    var sponsorArray = [SponsorDetails]()
                    
                    for (_,val): (String,JSON) in subJson {
                        
                        guard let name = val["name"].string ,let logo = val["logo"].string ,let link = val["link"].string else {
                            return
                        }
                        
                        let sponsor = SponsorDetails(name: name, logo: logo, link: link)
                        sponsorArray.append(sponsor)
                        
                    }
                    self.sponsorsModified.append(sponsorArray)
                    
                }
                
                print("Sponsor Modified!")
                
                self.sponsorCollection.reloadData()
                self.sponsorActivityIndicator.stopAnimating()
                self.sponsorActivityIndicator.isHidden = true
            }
            
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        print("Sections:",sponsorsModified.count)
        return sponsorsModified.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return sponsorsModified[section].count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SponsorCell", for: indexPath) as? SponsorCell {
            
            cell.configureCell(sponsor: sponsorsModified[indexPath.section][indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.bounds.width - 50
        let height: CGFloat = 150
        
        return CGSize(width: width, height: height)
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SponsorType", for: indexPath) as? SponsorTitleCell {
            
            header.configureCell(title: sponsorTitle[indexPath.section])
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let link = sponsorsModified[indexPath.section][indexPath.row].link
        
        UIApplication.shared.openURL(link)

    }
    
    
    func setRefreshController() {
        
        refreshControl = UIRefreshControl()
        
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "ChalkboardSE-Regular", size: 25) ]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Let go to dismiss!", attributes: attributes)
        
        refreshControl.tintColor = .clear
        
        refreshControl.backgroundColor = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0)
        
        if #available(iOS 10, *) {
            sponsorCollection.refreshControl = refreshControl
        } else {
            sponsorCollection.addSubview(refreshControl)
        }
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y > -80 {
            refreshControl.endRefreshing()
        } else {
            
            sponsorCollection.setContentOffset( scrollView.contentOffset, animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.alpha = 0
                
            }, completion: { (state) in
                print("State is: ",state)
                
                //self.dismiss(animated: true)
                self.performSegue(withIdentifier: "ShowDashboard", sender: nil)
                
            })
        }
        
    }
   
}
