//
//  PushNotificationManager.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-26.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()

        updateFirestorePushTokenIfNeeded()
    }
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users_table").document(userID)
            usersRef.setData(["fcmToken": token], merge: true)
            print("token is: \(token)")
            

        }
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
    }

    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM Token is: \(fcmToken)")
        updateFirestorePushTokenIfNeeded()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        print(userInfo)
        guard let theUserInform = userInfo as? [String : Any] else {return}
        //home page -> tab bar -> nav cont ->friend message collection v
        
        let mainView = UIStoryboard(name: "Main", bundle: nil)
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        var userInformationString = theUserInform["vc"] as? String
        
        if userInformationString == "friendMessageCollectionViewController" {
            let homepageVC : HomePageViewController = mainView.instantiateViewController(withIdentifier: "HomePage") as! HomePageViewController
            
            let friendMessageViewController = mainView.instantiateViewController(withIdentifier: "friendMessageCollectionViewController") as! FriendMessageCollectionViewController
            let friendNavi = UINavigationController(rootViewController: homepageVC)
            appDelegate.window?.rootViewController = friendNavi
            appDelegate.window?.makeKeyAndVisible()
            friendNavi.pushViewController(friendMessageViewController, animated: true)
        }
        
        else if userInformationString == "HomePage" {
            let homePageVC : HomePageViewController = mainView.instantiateViewController(withIdentifier: "HomePage") as! HomePageViewController
            NotificationCenter.default.post(name: NSNotification.Name("ConfirmTrackingAlert"), object: nil)
            appDelegate.window?.rootViewController = homePageVC
            appDelegate.window?.makeKeyAndVisible()
            
        }

        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

}
