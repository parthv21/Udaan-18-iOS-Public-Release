//
//  AboutVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 26/01/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import MessageUI

class AboutVC: UIViewController {

    @IBOutlet weak var titleBanner: UIView!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var versionLbl: UILabel!
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var githubLogo: UIImageView!
    
    @IBOutlet weak var forkMeBtn: UIButton!
    
    @IBOutlet weak var contactBtn: UIButton!
    
    @IBOutlet weak var gmailLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aboutTextView.delegate = self
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: titleBanner.bounds.height)
        
        gradientLayer.colors = [UIColor(red:0.42, green:0.91, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.12, green:0.86, blue:1.00, alpha:1.0).cgColor,UIColor(red:0.09, green:0.69, blue:0.80, alpha:1.0).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0,0.50]
        titleBanner.layer.insertSublayer(gradientLayer, at: 0)
        
        avatar.layer.cornerRadius = 50
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor(red:0.42, green:0.91, blue:1.00, alpha:1.0).cgColor
        avatar.layer.borderWidth = 2
        
        githubLogo.layer.borderColor = UIColor(red:0.06, green:0.42, blue:0.50, alpha:0.51).cgColor
        githubLogo.layer.borderWidth = 1
        
        gmailLogo.layer.borderColor = UIColor(red:0.06, green:0.42, blue:0.50, alpha:0.51).cgColor
        gmailLogo.layer.borderWidth = 1
        
        let version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        let build: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        
        versionLbl.text = "v "+version+" ("+build+")"
        
        
        
        let showMeGesture = UITapGestureRecognizer(target: self, action: #selector(showMe))
        showMeGesture.numberOfTapsRequired = 1
        avatar.addGestureRecognizer(showMeGesture)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.aboutTextView.setContentOffset(CGPoint.zero, animated: false)
    }

    @IBAction func forkMeTapped(_ sender: Any) {
        
        guard let url = URL(string: "https://github.com/parthv21/")  else
        {
            print("Can't get git hub url")
            return
            
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
  
    
    @IBAction func showMeTapped(_ sender: Any) {
        
        
    }
    
    @objc func showMe() {
        print("Tapped")
        performSegue(withIdentifier: "ShowMe", sender: avatar.image)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowMe" {
            
            if let destination = segue.destination as? FullImageVC, let avatar = sender as? UIImage {
                
                destination.passedPoster = avatar
                destination.showCallBtn = false
                
            }
            
        }
        
    }
}

extension AboutVC: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL, options: [:])
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL)
        }
        return true
    }
    
    
}

extension AboutVC: MFMailComposeViewControllerDelegate {
    @IBAction func contactTapped(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["parthv21@gmail.com"])
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert_ = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .destructive)
        sendMailErrorAlert_.addAction(dismiss)
        present(sendMailErrorAlert_, animated: true)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

