//
//  FollowMeViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-15.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


class FollowMeViewController: UIViewController {

    @IBOutlet weak var friendsCollectionVC: UICollectionView!
    
    @IBOutlet weak var followBTN: UIButton!
    
    let friendDB = FirebaseConstants.friendDataBase
    var myFriends = [Users]()
    var selectedUsers = [Users]()
    var myFriendCell = FriendCollectionViewCell()
    var friendsUIDArray = [String]()
    var followMeDB = FirebaseConstants.followMeDataBase
    var selectedDB = FirebaseConstants.selectedDatabase
    var currentState = "notSelected"
    var friendUID = String()
    
    override func viewDidLoad() {
        friendsCollectionVC.delegate = self
        friendsCollectionVC.dataSource = self
        friendsCollectionVC.allowsMultipleSelection = true
        
        followBTN.isEnabled = false
        fetchFriends()
        super.viewDidLoad()

    }

    
    @IBAction func followBTNPressed(_ sender: Any) {
        let sender = PushNotificationSender()
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        let usersRef = Firestore.firestore().collection("users_table").document(friendUID)
        guard let theEmail = Auth.auth().currentUser?.email else {return}
        usersRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            guard let myData = docSnapshot.data() else {return}
            guard let theToken = myData["fcmToken"] as? String else {return}
            sender.sendPushNotification(to: theToken, title: "Follow Them", body: "\(theEmail) would like to share their live location with you", vc: "HomePage")
        }
        tabBarController?.selectedIndex = 0
//        NotificationCenter.default.post(name: NSNotification.Name("StartLiveLocation"), object: nil)
        //NotificationCenter.default.post(name: NSNotification.Name("ConfirmTrackingAlert"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ShowTrackingView"), object: nil)
    }
    
    func fetchFriends() {

        guard let myUID = Auth.auth().currentUser?.uid else {
            return
        }

        
        friendDB.child(myUID).observe(.value) { (snapshot) in
            for friends in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = friends.value as? [String: AnyObject] {
                    let users = Users()
                    users.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                    users.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                    users.userID = dictionary["UID"] as? String ?? ""
                    self.myFriends.append(users)

                }
                DispatchQueue.main.async {
                    self.friendsCollectionVC.reloadData()
                }

            }
        }
    }
    func alertWolf() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.trackMeDatabase.child(myUID).observe(.value) { (snapshot) in
            print("Snapshot key is: \(snapshot.key)")
//            print("Snapshot key is: \(snapshot.key)")
//            if myUID == snapshot.key {
//                let alertController = UIAlertController(title: "Accepted", message: "User has accepted your Follow Me Request", preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
//                    print("Ok")
//                }
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }

        }
    }
    func bannerForTracking() {
        let locationServiceVC = LocationServicesViewController()
        if currentState == "reqSent" {
            locationServiceVC.myCircleTrackingView.isHidden = false
        }
    }
}
extension FollowMeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        myFriendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendCollectionViewCell
        
        let myFriendsCircle = myFriends[indexPath.row]
        myFriendCell.friendNameLabel.text = myFriendsCircle.nameOfUser
        
        if let profileImageURL = myFriendsCircle.profileImageURL {
            myFriendCell.friendImageView.loadImageUsingCache(urlString: profileImageURL)
        }
        
        return myFriendCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let theSelectedUser = selectedUsers.append(myFriends[indexPath.row])
        friendUID = myFriends[indexPath.row].userID
        
        let selectedIndexPath = collectionView.indexPathsForSelectedItems
        
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        myFriendCell = collectionView.cellForItem(at: indexPath) as! FriendCollectionViewCell
        myFriendCell.layer.borderWidth = 2.0
        myFriendCell.layer.borderColor = UIColor.gray.cgColor
        
        followBTN.isEnabled = true
        let selectedDictionary: NSDictionary = ["requestType": "sent", "myUID": myUID]
        
        if myFriendCell.isSelected == true {
            selectedDB.child(friendUID).setValue(selectedDictionary) { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.currentState = "reqSent"
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        friendUID = myFriends[indexPath.row].userID
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        myFriendCell = collectionView.cellForItem(at: indexPath) as! FriendCollectionViewCell
        myFriendCell.layer.borderWidth = 0
        myFriendCell.layer.borderColor = nil
        
    }
}
