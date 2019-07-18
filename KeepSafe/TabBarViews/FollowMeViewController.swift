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
    let friendDB = FirebaseConstants.friendDataBase
    var myFriends = [Users]()
    var myFriendCell = FriendCollectionViewCell()
    override func viewDidLoad() {
        friendsCollectionVC.delegate = self
        friendsCollectionVC.dataSource = self
        
        fetchFriends()
        super.viewDidLoad()

    }
    func fetchFriends() {
        guard let myUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        friendDB.child(myUID).observeSingleEvent(of: .value) { (snapshot) in
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
    
    
}




