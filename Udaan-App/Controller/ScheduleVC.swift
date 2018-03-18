//
//  ScheduleVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 13/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase

class ScheduleVC: UIViewController {

    @IBOutlet weak var scheduleWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        timetableRef.observe(.value) { (snapshot) in
            if let url = snapshot.value as? String {
                
                print("Url is: ",url)
                
                if let url = URL(string: url) {
                    
                    self.loadInWebView(url: url)
                    
                }
                
            } else {
                
                if let path = Bundle.main.path(forResource: "Demo", ofType: "pdf") {
                    
                    
                    if let url = Bundle.main.url(forResource: "Demo", withExtension: "pdf") {
                        
                        self.loadInWebView(url: url)
                    }
            
            }
        }
        
    }
    }
    
    @IBAction func dismissScheduleTapped(_ sender: Any) {
        print("Tapped")
        dismiss(animated: true, completion: nil)
    }
    
    func loadInWebView(url: URL) {
        
        let urlRequest = URLRequest(url: url)
        
        scheduleWebView.loadRequest(urlRequest)
    }
}
