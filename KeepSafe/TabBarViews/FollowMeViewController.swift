//
//  FollowMeViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-15.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

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
        Alert.showFollowConfirmationAlert(on: self)
        guard let myUID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let myEmail = Auth.auth().currentUser?.email else {return}
        selectedDB.child(myUID).observe(.value) { (snapshot) in
            for friendUID in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = friendUID.value as? [String: AnyObject] {
                    let uid = dictionary["friendUID"] as? String ?? ""
                    //let nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                    self.friendsUIDArray.append(uid)
                    
                    
                    let followMeDictionary: NSDictionary = ["sender": myEmail, "FollowMeLink": "\(myEmail) has requested a follow, please click here", "friendUID": uid]
                    self.followMeDB.childByAutoId().setValue(followMeDictionary, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error)
                        } else {
                            print("Follow request sent successfully")
                        }
                    })
                    
                    
                }
            }
        }

        
    }
    
    @objc func followButtonPressed() {
//        guard let myUID = Auth.auth().currentUser?.uid else {
//            return
//        }
//        guard let myEmail = Auth.auth().currentUser?.email else {return}
//        selectedDB.child(myUID).observe(.value) { (snapshot) in
//            for friendUID in snapshot.children.allObjects as! [DataSnapshot] {
//                if let dictionary = friendUID.value as? [String: AnyObject] {
//                    let uid = dictionary["UID"] as? String ?? ""
//                    let nameOfUser = dictionary["nameOfUser"] as? String ?? ""
//                    self.friendsUIDArray.append(uid)
//
//
//                    let followMeDictionary: NSDictionary = ["sender": myEmail, "FollowMeLink": "\(myEmail) has requested a follow, please click here", "toID": uid, "nameOfUser": nameOfUser]
//                    self.followMeDB.childByAutoId().setValue(followMeDictionary, withCompletionBlock: { (error, ref) in
//                        if error != nil {
//                            print(error)
//                        } else {
//                            print("Follow request sent successfully")
//                        }
//                    })
//
//
//                }
//            }
//        }
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
        let theSelectedUser = selectedUsers.append(myFriends[indexPath.row])
        friendUID = myFriends[indexPath.row].userID
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        myFriendCell = collectionView.cellForItem(at: indexPath) as! FriendCollectionViewCell
        myFriendCell.layer.borderWidth = 2.0
        myFriendCell.layer.borderColor = UIColor.gray.cgColor
        //print(myFriendCell.friendNameLabel.text)
        
        followBTN.isEnabled = true
        let selectedDictionary: NSDictionary = ["requestType": "sent", "friendUID": friendUID]

        if (currentState == "notSelected") {
            selectedDB.child(myUID).setValue(selectedDictionary) { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.currentState = "reqSent"
                }
            }
        }
//        if (currentState == "reqSent") {
//            followBTN.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
//
//        }
        
    }
    
    
}




