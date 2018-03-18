//
//  ViewController.swift
//  Udaan-App
//
//  Created by Parth Tamane on 24/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import iCarousel

class SignInVC: UIViewController, GIDSignInUIDelegate, iCarouselDataSource, iCarouselDelegate {

    //MARK: - Outlet
    
    @IBOutlet weak var carouselView: iCarousel!
    
    @IBOutlet weak var customSignInBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.type = .coverFlow
        carouselView.delegate = self
        carouselView.dataSource = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 3
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var itemView: UIImageView
        
        if let view = view as? UIImageView {
            itemView = view
            view.image = UIImage(named: "\(index+1).png")
        }else {
            itemView = UIImageView(frame: carouselView.frame)
            itemView.image = UIImage(named: "\(index+1).jpg")
            itemView.contentMode = .scaleAspectFit
        }
     
        return itemView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //configureSignInBtn()
        
    }
    
  
    
    
//    @objc func logIn() {
//
//
//    }
    
    @IBAction func logInTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    //Custom View Functions
    
//    func configureSignInBtn() {
//
//        customSignInBtn.addTarget(self, action: #selector(logIn), for: .touchUpInside)
//
//    }
}

