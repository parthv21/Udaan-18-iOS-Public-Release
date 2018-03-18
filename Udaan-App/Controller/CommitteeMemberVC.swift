//
//  CommitteeMemberVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 12/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase

class CommitteeMemberVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    var committeePosts = ["",
        "",
        "",
        "",
        "",
        "",
        "",
        ""]
    
    var committeeAvatar = [
        #imageLiteral(resourceName: "CP"),
        #imageLiteral(resourceName: "VCP"),
        #imageLiteral(resourceName: "Tech"),
        #imageLiteral(resourceName: "Security"),
        #imageLiteral(resourceName: "LA"),
        #imageLiteral(resourceName: "FA"),
        #imageLiteral(resourceName: "Hospitality"),
        #imageLiteral(resourceName: "Council")
    ]
    
    var committeNames = [ "Chair Person",
        "Vice Chair Person",
        "Tech Head",
        "Security",
        "Litrary Arts",
        "Fine Arts",
        "Hosiptality",
        "Student Council",
       
    ]
    
    let commiteeDiscription = [ "Nishant Bakhrey",
        "Sanskruti Jaipuria\nArpan Modi\nAastha Shah",
        "Shloak Gujar\nManas Shukala\nKaustubh Toraskar",
        "Nischint Jagdale\nNikhil Kulkarni\nPrathamesh Limaye\nNinad Jagdale",
        "Aditya Desai",
        "Ruman Kazi\nApurva Ghadi",
        "Vidhi Harsora\nAditya Khopkar\nGurpreet Kaur",
        "Rohit, Anushka, Divit, Disha, Naman,Prutha, Neil, Sharvika"
        
    ]
    
    let emoji = [ "🤠","💂🏻","💻","👮","📝","🎭","💃","🗣"]

    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var committeeCollection: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var titleBanner: UIView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return committeePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommitteeCell", for: indexPath) as? CommitteeCell {
            
            let committee = CommitteeMember(name: committeNames[indexPath.row], emoji: emoji[indexPath.row], rank: "\(indexPath.row)", position: committeePosts[indexPath.row], quote: commiteeDiscription[indexPath.row], avatar: committeeAvatar[indexPath.row])
            
            cell.configureCell(committee)
            
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isSmallScreen {
            return CGSize(width: view.bounds.width, height: 200)
        }
        
        return CGSize(width: view.bounds.width, height: 150)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        committeeCollection.delegate = self
        committeeCollection.dataSource = self


        titleBanner.addGradient()
        
        setRefreshController()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowAvatar", sender: committeeAvatar[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowAvatar" {
            
            if let destination = segue.destination as? FullImageVC, let avatar = sender as? UIImage {
                
                destination.passedPoster = avatar
                destination.showCallBtn = false
            }
            
        }
        
    }
    
    
    func setRefreshController() {
        
        refreshControl = UIRefreshControl()
        
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "ChalkboardSE-Regular", size: 25) ]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Let go to dismiss!", attributes: attributes)
        
        refreshControl.tintColor = .clear
        
        refreshControl.backgroundColor = UIColor(red:1.00, green:0.46, blue:0.46, alpha:1.0)
        
        if #available(iOS 10, *) {
            committeeCollection.refreshControl = refreshControl
        } else {
            committeeCollection.addSubview(refreshControl)
        }
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y > -80 {
            refreshControl.endRefreshing()
        } else {
            
            committeeCollection.setContentOffset( scrollView.contentOffset, animated: true)
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.alpha = 0
                
            }, completion: { (state) in
                
                //self.dismiss(animated: true)
                self.performSegue(withIdentifier: "ShowDashboard", sender: nil)
                
            })
        }
        
    }
    
    
}
