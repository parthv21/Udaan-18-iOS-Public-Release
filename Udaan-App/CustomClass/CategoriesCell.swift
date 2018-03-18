//
//  CategoriesCell.swift
//  Udaan-App
//
//  Created by Parth Tamane on 26/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase

class CategoriesCell: UICollectionViewCell {

    
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var categoryLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leadingTrainBumper: UIView!
    
    @IBOutlet weak var trainContainer: UIView!
    
    @IBOutlet weak var trailingTrainBumper: UIView!
    
    @IBOutlet weak var horizontalTrailingBumper: UIView!
    
    @IBOutlet weak var verticalTrailingBumper: UIView!
    
    @IBOutlet weak var horizontalLeadingBumper: UIView!
    
    @IBOutlet weak var verticalLeadingBumper: UIView!
    
    @IBOutlet weak var categoryBgImg: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activityIndicatorContainer: RoundUIView!
    
    var categoryNo: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1).cgColor
    }
    
    func configureCell(title categoryTitle: String, categoryNo: Int, isStarting:Bool, isEnding: Bool) {
    
        title.text = categoryTitle
        
        trainContainer.layer.cornerRadius = 10
        
        
        
        self.categoryNo = categoryNo
        
        categoryBgImg.image = categoriesBG[categoryNo]
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.activityIndicatorContainer.isHidden = true
        //
//        categoryBGRef.observe(.value, with: {(snapshot) in
//
//            self.activityIndicatorContainer.isHidden = false
//            self.activityIndicator.isHidden = false
//            self.activityIndicator.startAnimating()
//
//            if let value = snapshot.value as? [String] {
//
//                if value.indices.contains(categoryNo) {
//
//                    let urlString = value[categoryNo]
//
//                    if let url = URL(string: urlString) {
//
//                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//
//                            guard let data = data, error == nil else { print(error?.localizedDescription); return}
//
//                            DispatchQueue.main.async {
//
//                                self.categoryBgImg.image = UIImage(data: data)
//                                self.activityIndicator.stopAnimating()
//                                self.activityIndicator.isHidden = true
//                                self.activityIndicatorContainer.isHidden = true
//                            }
//
//                        }).resume()
//
//                    }
//                }
//            }
//        })
//

    }
    
}
