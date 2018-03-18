 //
//  AppDelegate.swift
//  Udaan-App
//
//  Created by Parth Tamane on 24/12/17.
//  Copyright © 2017 Parth Tamane. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMobileAds
import UserNotifications
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var storyboard: UIStoryboard?
    var redirectVC: UIViewController?
    var databaseRef: DatabaseReference!
    let userDefaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GADMobileAds.configure(withApplicationID: AppId)
        
        //userDefaults.set(0, forKey: "runs")
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            print("The app is launching for the first time. Setting UserDefaults...")
            
            do {
                try Auth.auth().signOut()
                print("Signed out")
            } catch {
                
            }
            
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.set(0, forKey: "runs")
            userDefaults.set(0, forKey: "messageCount")
            userDefaults.synchronize() // This forces the app to update userDefaults
            
            
        } else {
            
            print("The app has been launched before. Loading UserDefaults...")
            
            if let appRuns = userDefaults.value(forKey: "runs") as? Int {
                
                userDefaults.set(appRuns + 1, forKey: "runs")
            
            } else {
        
                userDefaults.set(1, forKey: "runs")
        
            }
            
            if let messageCount =  userDefaults.object(forKey: "messageCount") as? Int {
                print("Message count exists: ",messageCount)
            } else {
                print("Message count does not exist.")
                userDefaults.set(0, forKey: "messageCount")
            }
        }
        
        //MARK: - FCM Set Up
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        //UISettings
        
        let mainScreen = UIScreen.main.bounds
        
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "LaunchScreen").view!
        
        let colouredLogo = UIImageView(image: UIImage(named: "Logo-Coloured"))
        colouredLogo.center = CGPoint(x: mainScreen.width/2, y: mainScreen.height/2 - 50)
        colouredLogo.bounds = CGRect(x: 0, y: 0, width: mainScreen.width, height: 300)
        
        print("\nSCREEN WIDTH IS: ",UIScreen.main.bounds.width,"\n")
        
        if mainScreen.width <= 320 {
            
            isSmallScreen = true
            
        } else {
            
            isSmallScreen = false
        }
        
        
        //Google signin setup
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Login in status check
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
       
        //let signedIn
        user = Auth.auth().currentUser
        
        if user != nil {
            
            redirectVC = storyboard?.instantiateViewController(withIdentifier: "LoggedInVC")
            currentUser = databaseRoot.child("Users").child((user!.uid))
            //redirectVC?.view.addSubview(launchScreen)
            
        } else {
            
            
            redirectVC = storyboard?.instantiateViewController(withIdentifier: "SignInVC")
            //redirectVC?.view.addSubview(launchScreen)
        }
        
        if redirectVC != nil {
         
            redirectVC?.view.addSubview(launchScreen)
            self.window?.rootViewController = redirectVC
            
        } else {
            
            print("Error: Invalid redirect VC")
        }
        
        UIView.animate(withDuration: 1.2, animations: {
            
            if let logo = launchScreen.subviews[0] as? UIImageView {
                
                logo.transform = CGAffineTransform(translationX: 0, y: -500)
                logo.alpha = 0
            }
            
            launchScreen.alpha = 0
            launchScreen.transform = CGAffineTransform(translationX: 0, y: -500)
        })
        
        
        return true
    }
  
    

    
    //URL handeling for signin
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
    //Delegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    
        if let error = error {
            
            print("Error: Could not login\n \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken:
            authentication.idToken, accessToken: authentication.accessToken)
        
        print("Log: Signed in with provied\n \(credential.provider)")
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                
                print("Error: Could not authenticate with firebase!\n \(error) ")
                return
                
            } else {

                currentUser = databaseRoot.child("Users").child((user!.uid))
                
                self.databaseRef = Database.database().reference()
                
                self.databaseRef.child("Users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snapshot = snapshot.value as? NSDictionary
                    
                    if snapshot == nil {
                        
                        currentUser.child("name").setValue(user?.displayName)
                        
                        currentUser.child("email").setValue(user?.email)
                        
                    }
                    
                })
                
                //Moving over to dashboard
                self.window?.rootViewController?.performSegue(withIdentifier: "goToDashboard", sender: nil)
            
                
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        if let token = Messaging.messaging().fcmToken {
            
            //userDefaults.set(userFCMToken, forKey: "token")
            print("\n\n FCM Token is: ",token,"\n\n")

        } else {
            
            print("\n\nProblem in getting token\n\n")
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - Unused Methods
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

