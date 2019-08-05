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
        
        let usersRef = Firestore.firestore().collection("users_table").document(friendUID)
        guard let theEmail = Auth.auth().currentUser?.email else {return}
        usersRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            guard let myData = docSnapshot.data() else {return}
            guard let theToken = myData["fcmToken"] as? String else {return}
            sender.sendPushNotification(to: theToken, title: "Follow Them", body: "\(theEmail) would like to share their live location with you", vc: "HomePage")
        }
        tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name("StartLiveLocation"), object: nil)

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
        print(selectedIndexPath)
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        myFriendCell = collectionView.cellForItem(at: indexPath) as! FriendCollectionViewCell
        myFriendCell.layer.borderWidth = 2.0
        myFriendCell.layer.borderColor = UIColor.gray.cgColor
        
        followBTN.isEnabled = true
        let selectedDictionary: NSDictionary = ["requestType": "sent", "friendUID": friendUID]
        
        if myFriendCell.isSelected == true {
            selectedDB.child(myUID).setValue(selectedDictionary) { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.currentState = "reqSent"
                }
            }
        }
        
//        if (currentState == "notSelected") {
//            selectedDB.child(myUID).setValue(selectedDictionary) { (error, ref) in
//                if error != nil {
//                    print(error!)
//                } else {
//                    self.currentState = "reqSent"
//                }
//            }
//        }
//        if (currentState == "reqSent") {
//            followBTN.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
//
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        friendUID = myFriends[indexPath.row].userID
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        myFriendCell = collectionView.cellForItem(at: indexPath) as! FriendCollectionViewCell
        myFriendCell.layer.borderWidth = 0
        myFriendCell.layer.borderColor = nil
    }
    
    
}




