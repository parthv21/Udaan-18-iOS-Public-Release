//
//  FirebaseConstants.swift
//  Udaan-App
//
//  Created by Parth Tamane on 28/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import Foundation
import Firebase

let adDemo = true

let AppId = adDemo  ? "ca-app-pub-3940256099942544~1458002511" : "USER_ID" // 1st is demo appId, second is actual id

let eventListBannerUnitId = adDemo ? "ca-app-pub-3940256099942544/2934735716" : "BANNER_ID_1" // 1st is demo unitId, second is actual id

let dashboardBannerUnitId = adDemo ? "ca-app-pub-3940256099942544/2934735716" : "BANNER_ID_2" // 1st is demo unitId, second is actual id

let interstitialUnitId = adDemo ? "ca-app-pub-3940256099942544/4411468910" : "INTERSTETIAL_ID" // 1st is demo unitId, second is actual id

let databaseRoot: DatabaseReference = Database.database().reference().child("iOS")

var user: User!

var currentUser: DatabaseReference!

let fullEventsRef = databaseRoot.child("Events").child("SubEvents")

let eventRegistrationRef = databaseRoot.child("Events").child("Regestrations")

let userRegestrationRef = currentUser.child("Regestrations")

let categoriesRef = databaseRoot.child("Events").child("Categories")

let questionSetRef = databaseRoot.child("QuestionSet")

let committeeChats = databaseRoot.child("Messages")

let categoryBGRef = databaseRoot.child("Events").child("Categories-BG")

let committeeRef = databaseRoot.child("Committee")

let sponsorRef = databaseRoot.child("Sponsors")

let committeeFCMTokenRef = databaseRoot.child("CommitteeTokens")

let timetableRef = databaseRoot.child("Timetable").child("url")

let logsRef = databaseRoot.child("Logs")

let tokenRef = databaseRoot.child("Tokens")

let committee = ["EMAIL_ID_1","EMAIL_ID_2"]

var committeeTokens = [String]()

var categories = ["Featured","Performing Arts","Litrary Arts","Fun events"]
var categoriesBG = [#imageLiteral(resourceName: "Featured Events"),#imageLiteral(resourceName: "Perfoeming Arts"),#imageLiteral(resourceName: "Litrary Arts"),#imageLiteral(resourceName: "Fun Events")]

var eventPosterCache = [String:UIImage]()

