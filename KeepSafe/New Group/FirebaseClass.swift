//
//  FirebaseClass.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-18.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class FirebaseClass {
    //var myFriends = [Users]()
    let friendDataBase: DatabaseReference = Database.database().reference().child("friends")
    let myUID : String = Auth.auth().currentUser?.uid ?? ""
    
    private static func observeEvent() -> [Users]{
        let myUID : String = Auth.auth().currentUser?.uid ?? ""
        let theFriendDataBase: DatabaseReference = Database.database().reference().child("friends")
        var myFriends = [Users]()
        theFriendDataBase.child(myUID).observe(.value) { (snapshot) in
            for friends in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = friends.value as? [String: AnyObject] {
                    let users = Users()
                    users.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                    users.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                    users.userID = dictionary["UID"] as? String ?? ""
                    myFriends.append(users)
                }
            }
        }
        print(myFriends)
        return myFriends
    }
    
     static func fetchFriends() {
        observeEvent()
    
        }
    
    
}
