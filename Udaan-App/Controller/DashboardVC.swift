//
//  DashboardVC.swift
//  Udaan-App
//
//  Created by Parth Tamane on 24/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMobileAds
import StoreKit
import MessageUI
//import FirebaseMessaging

class DashboardVC: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,GADInterstitialDelegate, MFMailComposeViewControllerDelegate {

    //Firebase
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var viewChatBtn: UIButton!
    
    //Options
    
    @IBOutlet weak var optionsParent: UIStackView!
    @IBOutlet weak var quizContainer: UIView!
    @IBOutlet weak var optionsContainer: UIStackView!
    @IBOutlet dynamic var option1: OptionButton!
    @IBOutlet dynamic var option2: OptionButton!
    @IBOutlet dynamic var option3: OptionButton!
    @IBOutlet dynamic var option4: OptionButton!
   
    @IBOutlet weak var quizQuestionLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
   
    @IBOutlet weak var quizContainerOffsetTop: NSLayoutConstraint!
    
    @IBOutlet weak var topOptionContainer: UIStackView!
    
    @IBOutlet weak var bottomOptionContainer: UIStackView!
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
     @IBOutlet weak var dashboardAdsStackview: UIStackView!
    
    @IBOutlet weak var viewTimetableBtn: UIButton!
    
    @IBOutlet weak var hideAdsBtn: CustomButton!
    
    @IBOutlet weak var sideNavBtn: UIButton!
    @IBOutlet weak var bannerAdView: GADBannerView!
    
    @IBOutlet weak var reportBugBtn: UIButton!
    
    
    
    // MARK: - Constraints

    @IBOutlet weak var displayPictureWidth: NSLayoutConstraint!
    
    @IBOutlet weak var displayPictureHeight: NSLayoutConstraint!
    
    @IBOutlet weak var quizContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoryLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var favouriteLblHeight: NSLayoutConstraint!
   
    @IBOutlet weak var savedCollectionBottomOffset: NSLayoutConstraint!
    
    @IBOutlet weak var savedCollection: UICollectionView!
    
    @IBOutlet weak var quizLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesActivityIndicator: UIActivityIndicatorView!
    
    let banner = UIView()
    let messageLbl = UILabel()
    var correctOption: Int = 0
    var correctAnswer: String = ""
    var noQuiz : Bool = true
    var totalQuestions = 0
    var stackIsHorizontal = false
    let reviewRequestRuns = [15,25,40]
    
    var interstitial: GADInterstitial!
    
    let horizontalPopOrder = [
        [1,2,3,4],
        [2,1,4,3],
        [3,1,4,2],
        [4,3,2,1]]
    
    let verticalPopOrder = [
    
        [1,2,3,4],
        [2,1,3,4],
        [3,4,2,1],
        [4,3,2,1],
    ]
    
    let defaults = UserDefaults.standard
    
    var heightLeft = CGFloat()
    
    //var categories = [String]()
    var favourites = [String]()
    
    var user: User!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        user = Auth.auth().currentUser
        
        Messaging.messaging().subscribe(toTopic: "notif")
        
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        savedCollection.delegate = self
        savedCollection.dataSource = self
        
        bannerAdView.adUnitID = dashboardBannerUnitId
        bannerAdView.rootViewController = self
        bannerAdView.load(GADRequest())
        
        viewChatBtn.layer.cornerRadius = 10
        viewChatBtn.layer.masksToBounds = true
        
        quizContainer.addGradient()
        
        if traitCollection.forceTouchCapability == .available {
            print("3D Touch Available")
            registerForPreviewing(with: self, sourceView: categoriesCollection)
        } else {
            print("3D Touch Not Available")
            
        }
        
        //MARK: - Interstitial Ads Config
        
        interstitial = createAndLoadInterstitial()
        
        let savedLayout = savedCollection.collectionViewLayout as? UICollectionViewFlowLayout
        
        savedLayout?.sectionInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
     
        //defaults.set(0, forKey: "answered")
        //defaults.set(false, forKey: "adShown")
        
        if defaults.object(forKey: getDate()) == nil {
            
            defaults.set(true, forKey: getDate())
            defaults.set(0, forKey: "answered")
            defaults.set(false, forKey: "adShown")
        }
        
        fetchQuestion { (question) in
            self.setQuestion(question: question)
        }
        
        loadScore { (score) in
            self.scoreLbl.text = String(score)
            if score == 0 {
                currentUser.child("Score").setValue(0)
            }
        }
        
        setProfileImage()
        
        loadSaved()
        
        askReview()
        
        changeStackViewOrientation(makeHorizontal: !isSmallScreen)
        
        UserDefaults.standard.addObserver(self, forKeyPath: "messageCount", options: NSKeyValueObservingOptions.new, context: nil)
        
     
        checkForNewMessages()
        
        committeeFCMTokenRef.observe(.value, with: { (snapshot) in
            
            print("\n Fetching Committee Tokens")
            
            if let value = snapshot.value as? Dictionary<String,String> {
                committeeTokens = []
                
                for (_,token) in value {
                    committeeTokens.append(token)
                }
                
                print("New committee FCM tokens are:\n",committeeTokens,"\n")
            }
        })
        
        logUser()
    
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch traitCollection.forceTouchCapability {
        case .available:
            print("Available")
            registerForPreviewing(with: self, sourceView: view)

        case .unavailable:
            print("Unavailable")
        case .unknown:
            print("Unknown")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        if isSmallScreen {
            
            displayPictureWidth.constant = 80
            displayPictureHeight.constant = 80
            userProfileImage.layer.cornerRadius = 40
            
        } else {
            
            displayPictureWidth.constant = 100
            displayPictureHeight.constant = 100
            userProfileImage.layer.cornerRadius = 50
        }
        
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.borderWidth = 5
        //userProfileImage.layer.borderColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 0.8).cgColor
        userProfileImage.layer.borderColor = UIColor(red:0.06, green:0.42, blue:0.50, alpha:0.51).cgColor
        heightLeft = self.view.frame.height - quizContainerHeight.constant
        
        categoriesHeight.constant = ( heightLeft - categoryLblHeight.constant ) / 2.7
        
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "messageCount" {
            
            print("Message Count is updated!!!")
            
            if view.window != nil {
                print("Dash board in vc")
                self.viewChatBtn.setTitle( "💬❇️", for: .normal)
            } else {
                print("Dashboard VC is not visible")
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        
        if isSmallScreen {
            
            DispatchQueue.main.asyncAfter(deadline: ( .now() + 10 ), execute: {
                
                self.hideDashboardBanner()
            })
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: ( .now() + 20 ), execute: {
                
                self.hideDashboardBanner()
            })
        }
        
    }
    
    
    func checkForNewMessages() {
        
        committeeChats.observe(.value) { (snapshot) in
            
            let messageCount = self.defaults.object(forKey: "messageCount") as? Int
            
            var updatedMessageCount = 0
            
            guard let user = Auth.auth().currentUser else { print("User unavailable (DASHBOARD VC).") ;return }
            
            let recMail = (user.email)!
            
            if let value = snapshot.value as? Dictionary<String,Any> {
                
                for (_,message) in value {
                    
                    if committee.contains(recMail) {
                        
                        updatedMessageCount += 1
                        
                    } else {
                        
                        if let message = message as? Dictionary<String,Any> {
                            
                            let rec = message["rec_email"] as! String
                            let sender = message["email"] as! String
                            
                            if rec == recMail && recMail != sender || rec == "All" {
                                
                                updatedMessageCount += 1
                            }
                        }
                    }
                }
            }
            
            //print("Message stats- old count: ",messageCount,"new count: ",updatedMessageCount)
            
            
            if messageCount == nil || messageCount != updatedMessageCount {
                self.defaults.set(updatedMessageCount, forKey: "messageCount")
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        
        var interstitial = GADInterstitial(adUnitID: interstitialUnitId)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func getAppRuns() -> Int {
        
        if let appRuns = defaults.value(forKey: "runs") as? Int {
            
            return appRuns
        }
        return 0
    }
    
    func askReview() {
        
        var NO_OF_REVIEW_REQUESTS = defaults.object(forKey: "reviewCount") as? Int
        
        if NO_OF_REVIEW_REQUESTS == nil {
            print("NO_OF_REVIEW_REQUESTS not set")
            defaults.set(1, forKey: "reviewCount")
            NO_OF_REVIEW_REQUESTS = 0
        } else {
            
            if let reviewCount = NO_OF_REVIEW_REQUESTS {
                
                defaults.set(reviewCount + 1, forKey: "reviewCount")
                print("NO_OF_REVIEW_REQUESTS: ",reviewCount)
            }
        }
 
        if !reviewRequestRuns.contains(getAppRuns()) {

            print("Not a good day to ask for review")
            return
        }

        if #available(iOS 10.3, *) {
            
            if NO_OF_REVIEW_REQUESTS! < 3 {
                SKStoreReviewController.requestReview()
            } else {
                
                DispatchQueue.main.async {
                    
                    self.dispAppReviewAlert()
                }
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.dispAppReviewAlert()
            }
        }
    }
    
    func dispAppReviewAlert() {
        
        DispatchQueue.main.async {
            
            let rateAppAlert = UIAlertController(title: "Rate Udaan App", message: "If you enjoy using Udaan App and find it useful, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support! 👊🏻", preferredStyle: .alert)
            
            let rateAction = UIAlertAction(title: "Rate Now", style: .default, handler: { (action) -> Void in
                
                if let redirectUrl = URL(string: appStoreUrl) {
                    
                    if #available(iOS 10.0, *) {
                        
                        UIApplication.shared.open(redirectUrl, options: [:], completionHandler: nil)
                        
                    } else {
                        
                        UIApplication.shared.openURL(redirectUrl)
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "Maybe Later", style: .destructive, handler: { (alert) -> Void in
                
                self.dismiss(animated: true, completion: nil)
            })
            
            rateAppAlert.addAction(rateAction)
            rateAppAlert.addAction(cancelAction)
            
            self.present(rateAppAlert, animated: true)
            
        }
        
    }
    
    func changeStackViewOrientation(makeHorizontal horizontal: Bool ) {
        
        if horizontal {
            
            stackIsHorizontal = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.quizLblHeight.constant = 80
                
                self.topOptionContainer.axis = .horizontal
                self.bottomOptionContainer.axis = .horizontal
            })
        } else {
            
            stackIsHorizontal = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.quizLblHeight.constant = 60
                
                self.topOptionContainer.axis = .vertical
                self.bottomOptionContainer.axis = .vertical
            })
        }
    }
    
    // MARK: - Load Favourites
    func loadSaved() {
        
        userRegestrationRef.observe(.value, with: {(snapshot) in
            
            self.favourites.removeAll()
            
            if let val = snapshot.value as? Dictionary<String,Any>{
                
                for (index,value) in val {
                    
                    let categoryId = index.components(separatedBy: "-")[1]
                    
                    if let events = value as? Dictionary<String,Bool> {
                        
                        for (index,_) in events {
                            
                            let eventId = index.components(separatedBy: "-")[1]
                           
                            self.favourites.append("\(categoryId)-\(eventId)")
                        }
                        
                    }
                    
                }
            }
            self.savedCollection.reloadData()
        })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoriesCollection {
            
            performSegue(withIdentifier: "ShowEvents", sender: indexPath.row)
            
        } else if collectionView == savedCollection {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? SavedCell {
            
                if favourites.count == 0 {
                    return
                }
                
                performSegue(withIdentifier: "ShowZoomedImage", sender: cell.posterData)
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowEvents" {
        
            if let destination = segue.destination as? EventListVC, let categoryNo = sender as? Int {
               
                destination.categoryIndex = categoryNo
                
            }
            
        } else if segue.identifier == "ShowZoomedImage" {
            
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoriesCollection {
            
            return categories.count
            
        } else if collectionView == savedCollection {
            
            if favourites.count == 0 {
                
                return 1
            }
            
            return favourites.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoriesCollection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as? CategoriesCell
            
            if let cell = cell {
                
                cell.configureCell(title: categories[indexPath.row], categoryNo: indexPath.row, isStarting: false, isEnding: false)
                
                return cell
            }
            
        } else if collectionView == savedCollection {
            
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCell", for: indexPath) as? SavedCell
            
            if let cell = cell {
            
                if favourites.count == 0 {
                    
                    cell.bgImg.image = #imageLiteral(resourceName: "Empty")
                    cell.title.text = "Register for Events!"
                    cell.activityIndicator.isHidden = true
                    cell.unregisterBtn.isHidden = true
                    cell.activityIndicatorContainer.isHidden = true
                    return cell
                }
               
                if favourites.indices.contains(indexPath.row) {
                    
                    let eventRef = favourites[indexPath.row].components(separatedBy: "-")
                    
                    if eventRef.count > 1 {
                     
                        fullEventsRef.child(eventRef[0]).child(eventRef[1]).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            
                            if let event = snapshot.value as? Dictionary<String,Any> {
                                
                                let eventDetails = EventDetails(event: event)
                                
                                cell.configureCell(eventDetails: eventDetails)
                                
                            }
                        })
                    }
                    
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == categoriesCollection {
        
            let height = categoriesHeight.constant - 8
            //let width = height * 1.618
            let width = 16 * height / 9
           
            return CGSize(width: width, height: height)
            
        } else if collectionView == savedCollection {
            
            let width = ( self.view.frame.width - 30 )

            let height = min(width * 9 / 16,savedCollection.bounds.height - 10)
            
            return CGSize(width: width, height: height)
        }
        
        return CGSize(width: 40, height: 40)
    }
    
    func loadScore(completed:@escaping (Int) -> ()) {
        
        
        currentUser.child("Score").observe(.value, with: {(snapshot) in
            
            var fetchedScore: Int!
            
            if let score = snapshot.value as? Int {
                
                fetchedScore = score
            } else {
                
                fetchedScore = 0
                
            }
            
            completed(fetchedScore)
        })
    }
 
    func fetchQuestion(completed completion: @escaping (Dictionary<String,String>) -> ()) {

        
        var question = Dictionary<String,String>()
        var questionCount = 0
        
        questionSetRef.child(getDate()).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? NSArray {
                
                self.totalQuestions = snapshotValue.count - 1
            
                
                for snapDict in snapshotValue {
                    
                    if var entry = snapDict as? Dictionary<String,Any> {
                        
                        if questionCount == self.getAnsweredQuestionsCount() {
                        
                            for (index,value) in entry {
                                
                                if let value = value as? Int {
                                    
                                    question[index] = "\(value)"
                           
                                } else if let value = value as? String {
                                        
                                        question[index] = value
                                    }
                            }
                            
                            break
                        }
                        questionCount += 1
                    }
                }
            }
            
            completion(question)
        })
    }
    
    
    
    func setQuestion(question: Dictionary<String,String>) {
        
        let answered = getAnsweredQuestionsCount()
        
        if answered < totalQuestions && question.count >= 5 {  //Replaced 3 by totalQuestions
        
            noQuiz = false
            quizQuestionLbl.text = "\(answered + 1)) " + question["qes"]!
            option1.setTitle(question["op1"], for: .normal)
            option2.setTitle(question["op2"], for: .normal)
            option3.setTitle(question["op3"], for: .normal)
            option4.setTitle(question["op4"], for: .normal)
            correctOption = Int(question["ans"]!)!
            correctAnswer = question["op\(correctOption)"]!
            
            if !isSmallScreen {
               
                if let optionType = Int(question["longOption"]!) {
                    
                    if optionType == 1 {
                        
                        changeStackViewOrientation(makeHorizontal: false)
                        
                    } else {
                        
                        changeStackViewOrientation(makeHorizontal: true)
                      
                    }
                    
                }
                
            }
            
        } else {
            
            
            quizQuestionLbl.text = "Come again later for more quiz! :)"
            option1.setTitle("--", for: .normal)
            option2.setTitle("--", for: .normal)
            option3.setTitle("--", for: .normal)
            option4.setTitle("--", for: .normal)
            noQuiz = true
            
            if reviewRequestRuns.contains(getAppRuns()) {
                
                print("Not a good day to show interstitial ad")
                return
            }
            
            if let addShown = defaults.object(forKey: "adShown") as? Bool {
                
                if !addShown && totalQuestions != 0 {
                    
                    defaults.set(true, forKey: "adShown")
                    interstitial.present(fromRootViewController: self)
                    
                }
            }
        }
    }
    
    func getDate() -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "ddMMyy"
        
        let result = formatter.string(from: date)
    
        return result
    }
    
    func setProfileImage() {
        
        let profileURL = Auth.auth().currentUser?.photoURL
        
        if let URL = profileURL {
            
            URLSession.shared.dataTask(with: URL) { (data, response, error) in
                
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    
                    self.userProfileImage.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
    
    func popButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: optionGrowDuration, animations: {
            
            sender.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            
        }) { (test) in
            
            UIView.animate(withDuration: optionShrinkDuration, animations: {
                
                sender.alpha = 0
                sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            })
        }
    }
    
    // MARK: IBAction
    
    @IBAction func viewChats(_ sender: Any) {
        
        self.viewChatBtn.setTitle( "💬", for: .normal)
  
    }
    
    func digitToAlpha(_ option: Int) -> String {
        
        let ASCIICode = 64 + option
        let c = Character(UnicodeScalar( ASCIICode )!)
        return "\(c)"
    }
    
    func displayQuizResult(isCorrect: Bool) {
        
        let banerOriginRef = optionsParent.convert(optionsParent.bounds.origin, to: self.view)
        let p = optionsContainer.convert(optionsContainer.bounds.origin, to: self.view)
        
        let resultBannerX = banerOriginRef.x + optionsContainer.frame.width/2
        let resultBannerY = p.y + optionsContainer.frame.height/2 - 2
        
        let resultBanerOrignalWidth = ( optionsContainer.bounds.width - 6 ) / 20
        let resultsBannerOrignalHeight = optionsContainer.bounds.height / 20
        
        banner.frame = CGRect(x: resultBannerX, y: resultBannerY, width: resultBanerOrignalWidth, height: resultsBannerOrignalHeight)
        banner.alpha = 0
        quizContainer.addSubview(banner)
        
        banner.addSubview(messageLbl)

        messageLbl.frame = CGRect(x: banerOriginRef.x + 4, y: p.y, width: resultBanerOrignalWidth * 20 , height: resultsBannerOrignalHeight * 20 )
        messageLbl.textColor = UIColor.white
        messageLbl.textAlignment = NSTextAlignment.center
        messageLbl.font = UIFont(name: "ChalkboardSE-Bold", size: 17)
        
        messageLbl.numberOfLines = 0
        
        let proceedGesture = UITapGestureRecognizer(target: self, action: #selector(renderNextQuestion))
        proceedGesture.numberOfTapsRequired = 1
        banner.addGestureRecognizer(proceedGesture)
        
        if isCorrect {
            
            banner.backgroundColor = UIColor(red:0.47, green:0.97, blue:0.56, alpha:1.0)
            messageLbl.text = "✔︎\nTap To Continue"
            setScore(isCorrect: true)
            
        } else {
            
            banner.backgroundColor = UIColor.red
            messageLbl.text = "✘\n\(digitToAlpha(correctOption))) \(correctAnswer)\nTap To Continue"
            setScore(isCorrect: false)
            
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.banner.alpha = 0.8
            self.banner.transform = CGAffineTransform(scaleX: 20.0, y: 20.0)
            self.banner.layer.cornerRadius = 0.5
            
        }, completion: { (true) in
            
            self.view.addSubview(self.messageLbl)
        })
    }

    @objc func renderNextQuestion() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.banner.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.banner.alpha = 0
            self.messageLbl.text = ""
            
        }) { (true) in
            
            UIView.animate(withDuration: 0.3 , animations: {
                
                self.option1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.option1.alpha = 1
                self.option2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.option2.alpha = 1
                self.option3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.option3.alpha = 1
                self.option4.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.option4.alpha = 1
              
            }, completion: { (true) in
              
                self.fetchQuestion(completed: { (question) in
                    
                    self.setQuestion(question: question)
                })
            })
        }
        
    }
    
    func setScore(isCorrect: Bool) {
    
        loadScore(completed: { (score) in
            
            questionSetRef.child(self.getDate()).child(String(self.getAnsweredQuestionsCount())).child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    print("Trying to answer same question again")
                    
                } else {
                    //Test this regorously
                    
                    if isCorrect {
                        
                             self.scoreLbl.pushTransition(0.5)
                             self.scoreLbl.text = String(( Int(self.scoreLbl.text!)! + 1 ))
                            currentUser.child("Score").setValue( score + 1)
                        questionSetRef.child(self.getDate()).child(String(self.getAnsweredQuestionsCount())).child((Auth.auth().currentUser?.uid)!).setValue("correct")
                        
                    } else {
                        
                        
                        questionSetRef.child(self.getDate()).child(String(self.getAnsweredQuestionsCount())).child((Auth.auth().currentUser?.uid)!).setValue("incorrect")
                    }
                }
            })
        })
    }
    
    func getAnsweredQuestionsCount() -> Int {
        
        if let answered = defaults.object(forKey: "answered") as? Int {
            
            return answered
            
        }
        return 0
    }
  
    func executeButtonPop(triggeringBtnID: Int) {
        
        let popOrder = stackIsHorizontal ? horizontalPopOrder : verticalPopOrder
    
        if let btn1 = value(forKey: getBtnName(id: popOrder[triggeringBtnID][0])) as? OptionButton {
            popButton(btn1)
            
            DispatchQueue.main.asyncAfter(deadline: (.now() + optionGrowDuration - optionCascadeDifference), execute: {
                
                if let btn2 = self.value(forKey: self.getBtnName(id: popOrder[triggeringBtnID][1])) as? OptionButton {
                    
                    self.popButton(btn2)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + optionGrowDuration - optionCascadeDifference, execute: {
                        
                        if let btn3 = self.value(forKey: self.getBtnName(id: popOrder[triggeringBtnID][2])) as? OptionButton {
                           
                            self.popButton(btn3)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + optionGrowDuration - optionCascadeDifference , execute: {
                                
                                if let btn4 = self.value(forKey: self.getBtnName(id: popOrder[triggeringBtnID][3])) as? OptionButton {
                                    
                                    self.popButton(btn4)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + optionAnimationDuration , execute: {
                                        
                                        if self.correctOption == (triggeringBtnID + 1) {
                                            
                                            self.displayQuizResult(isCorrect: true)
                                        
                                        } else {
                                            
                                            self.displayQuizResult(isCorrect: false)
                                        }
                                    })//1
                                }
                            })//2
                        }
                    })//3
                }
            })//4
        }
    }
   
    func getBtnName(id: Int) -> String {
        return "option\(id)"
    }
    
    @IBAction func quizOptionTapped(_ sender: UIButton) {
        
        let answered = getAnsweredQuestionsCount()
       
        if answered >= totalQuestions || noQuiz{
            
            return
        }
        defaults.set(answered + 1, forKey: "answered")
      
        executeButtonPop(triggeringBtnID: sender.tag)
    }
    
    @IBAction func hideDashboardAdTapped(_ sender: Any) {
        hideDashboardBanner()
    }
    
    func hideDashboardBanner() {
        
        
        
        self.sideNavBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        UIView.animate(withDuration: 0.3) {
            
            self.reportBugBtn.isHidden = false
            self.viewTimetableBtn.isHidden = false
            self.sideNavBtn.isHidden = false
            
            self.hideAdsBtn.isHidden = true
            self.bannerAdView.isHidden = true
            self.dashboardAdsStackview.spacing = 3
            
            self.dashboardAdsStackview.distribution = .fillEqually
        }
        
    }
    
    @IBAction func reportBugTapped(_ sender: Any) {
    
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
        mailComposerVC.setSubject("Udaan App Bug Report")
        mailComposerVC.setMessageBody("I have found some bugs in Udaan App. This is the problem I am experiencing.\n\n", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert_ = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .destructive)
        sendMailErrorAlert_.addAction(dismiss)
        present(sendMailErrorAlert_, animated: true)
    }
    
    func logUser() {
        
        let name = user.displayName?.replacingOccurrences(of: " ", with: "_") ?? ""
        var uid = user.uid
        let index = uid.index(uid.startIndex, offsetBy: 6)
        uid = uid.substring(to: index)
        
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
        
        let key = "\(name)(\(uid))"

        logsRef.child(key).setValue(timestamp)
        
    }
    
    // MARK: - MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showSideNavTapped(_ sender:
        Any) {
        
        performSegue(withIdentifier: "ShowSideNav", sender: nil)
    }
    
    @IBAction func sideNavDisplaySwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        performSegue(withIdentifier: "ShowSideNav", sender: nil)
    }
    
    var docController: UIDocumentInteractionController?
    
    
    @IBAction func unwindToDashboardTapped(segue: UIStoryboardSegue) {
        
    }
    
    
   
}

//MARK: - 3D Touch Handling Extension
extension DashboardVC:  UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = categoriesCollection.indexPathForItem(at: categoriesCollection.convert(location, from: view)) else {
            return nil
        }

        let eventList = storyboard?.instantiateViewController(withIdentifier: "EventList") as! EventListVC

        eventList.categoryIndex = indexPath.row

        eventList.preferredContentSize = view.bounds.size


        previewingContext.sourceRect = view.frame

        return eventList
  
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        present(viewControllerToCommit, animated: true)
    }
    
}
