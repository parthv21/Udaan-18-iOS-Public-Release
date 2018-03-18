//
//  FullImageVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 27/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit

class FullImageVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet var imageScrollView: UIScrollView!
    
    @IBOutlet weak var dismissBtutton: UIButton!
    
    @IBOutlet weak var callOrganizer: UIButton!
    @IBOutlet weak var callBackupOrganizer: UIButton!
    
    @IBOutlet weak var callBtnsContainer: UIStackView!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var yOffset: CGFloat = -10000
    
    var passedPoster = UIImage()
    var posterImage :  UIImageView!
    
    
    
    var zoomed = false
    var minZoomScale = CGFloat(0)
    var maxZoomScale = CGFloat(0)
    
    var contactName: String = ""
    var contactNumber: String = ""
    
    var backupContactName: String = ""
    var backupContactNumber: String = ""

    var showCallBtn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView.delegate = self
       
        posterImage = UIImageView(image: passedPoster)
        imageScrollView.addSubview(posterImage)
        //imageScrollView.contentSize = posterImage.bounds.size
        if showCallBtn {
            imageScrollView.bounds = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: view.bounds.height - 100)
            imageScrollView.contentSize = CGSize(width: self.view.bounds.width, height: view.bounds.height - 100)
        } else {
             imageScrollView.bounds = self.view.bounds
            imageScrollView.contentSize = posterImage.bounds.size
        }
        

        let widthScale = imageScrollView.bounds.size.width / posterImage.bounds.size.width
        let heightScale = imageScrollView.bounds.size.height / posterImage.bounds.size.height
        
        minZoomScale = min(widthScale,heightScale)
        maxZoomScale = 2 * max(widthScale,heightScale)
        
        imageScrollView.minimumZoomScale = minZoomScale
        imageScrollView.maximumZoomScale = 4
        imageScrollView.setZoomScale(minZoomScale, animated: true)
        
        dismissBtutton.layer.cornerRadius = 20
        
        let zoomGesture = UITapGestureRecognizer(target: self, action: #selector(toggleZoom))
        zoomGesture.numberOfTapsRequired = 2
        
        imageScrollView.addGestureRecognizer(zoomGesture)

        toggleCallBtn(show: showCallBtn)
        
        callOrganizer.setTitle("📞 "+contactName, for: .normal)
        
        callBackupOrganizer.setTitle("📞 "+backupContactName, for: .normal)
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
     
        setInset()
    }
    
    @objc func toggleZoom() {

        if !zoomed {
            
            imageScrollView.setZoomScale(maxZoomScale, animated: true)
            
        } else {
            
            imageScrollView.setZoomScale(minZoomScale, animated: true)
        }
        
        zoomed = !zoomed
        
        print("Toggle zoom (Zoomed: \(zoomed) ",imageScrollView.contentSize)

        
    }
    
    func setInset() {
        
        let imageViewSize = posterImage.frame.size
        let scrollViewSize = imageScrollView.bounds.size
        var verticalPadding : CGFloat = 0

        verticalPadding = imageViewSize.height <= scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0

        let horizontalPadding = imageViewSize.width <= scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        print("Poster Width: ",imageViewSize.width," Scroll View Width: ", scrollViewSize.width)
        
        print("Vertical padding: ",verticalPadding, "Horizontal Padding: ", horizontalPadding)
        
        if showCallBtn {
            
            imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding + 100 , right: horizontalPadding)
            
        } else {
            imageScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding + 10, right: horizontalPadding)
        }
        
    }
    
    
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        setInset()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return posterImage
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("Offset (before):", scrollView.contentOffset.y)
        yOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("Offset: (after)", scrollView.contentOffset.y)
        
        if (yOffset > scrollView.contentOffset.y ) {
            
            yOffset = -1000
            
            if !zoomed {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.alpha = 0
                    
                }, completion: { (state) in
                    if state {
                        
                        
                        
                        self.dismiss(animated: false, completion: nil)

                    }
                })
                
            }
        }

    }
    
    
    @IBAction func dismissZoomedImageWithButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func callOrganizerTapped(_ sender: Any) {
        
        callNumber(number: contactNumber)
        
    }
    
    @IBAction func callBackupOrganizerTapped(_ sender: Any) {
        
        callNumber(number: backupContactNumber)
        
    }
    
    func callNumber(number: String) {
        
        print("Attempting to call: ",number,"\n")
        
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
    
    
    func toggleCallBtn(show: Bool) {
        
        if show {
            
            
            callBtnsContainer.isHidden = false
            scrollViewBottomConstraint.constant = 100
            
        } else {
            
            callBtnsContainer.isHidden = true
            scrollViewBottomConstraint.constant = 0
            
        }
        
    }
    
    
}
