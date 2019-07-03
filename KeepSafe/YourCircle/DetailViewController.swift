//
//  DetailViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-18.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import PMSuperButton




class DetailViewController: UIViewController {
    
    var nameOfUser : String = "No Name"
    var email : String = "No Email"
    var profileImage = UIImage()
    var friendsUID : String = ""
    
    var friendProfileImageURL: String = ""
    
    var databaseRef : DatabaseReference!
    var currentState = "notFriends"
    var friendRequestDatabase = FirebaseConstants.friendRequestDatabase
    var friendDataBase = FirebaseConstants.friendDataBase
    var userDatabase = FirebaseConstants.userDatabase
    
    
    //NEW VARS:
    var users = Users()
    var otherUser: NSDictionary?
    var loggedInUserData: NSDictionary?
    //var newDatabaseRef: DatabaseReference?
    
    //END NEW VARS
    @IBOutlet weak var addfriendBTN: UIButton!
    @IBOutlet weak var declineFriendBTN: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseRef = Database.database().reference()
        nameOfUserLabel.text = nameOfUser
        emailLabel.text = email
        profileImageView.image = profileImage
        print("friend uid is: \(friendsUID)")
        currentState = "notFriends"
        fetchUserProfile()
        
        
    }
    
    
    func fetchUserProfile() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        friendRequestDatabase.child(myUID).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            if(snapshot.hasChild(self.friendsUID)) {
                let reqType: String = snapshot.childSnapshot(forPath: self.friendsUID).childSnapshot(forPath: "requestType").value as! String
                if(reqType == "received") {
                    self.currentState = "reqReceived"
                    //self.addfriendBTN.isEnabled = true
                    self.addfriendBTN.setTitle("Accept Friend Request", for: .normal)
                    //                    self.declineFriendBTN.isHidden = false
                    //                    self.declineFriendBTN.isEnabled = true
                    
                    
                } else if (reqType == "sent") {
                    self.currentState = "reqSent"
                    //self.addfriendBTN.isEnabled = true
                    self.addfriendBTN.setTitle("Cancel Friend Request", for: .normal)
                    //                    self.declineFriendBTN.isHidden = true
                    //                    self.declineFriendBTN.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func addFriendBTNPressed(_ sender: Any) {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        let otherUID = friendsUID
        
        
        if (currentState == "notFriends") {
            friendRequestDatabase.child(myUID).child(otherUID).child("requestType").setValue("sent") { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.friendRequestDatabase.child(otherUID).child(myUID).child("requestType").setValue("received", withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error!)
                            
                            
                        } else {
                            //print("add friends")
                            self.currentState = "reqSent"
                            
                            
                            //self.addfriendBTN.isEnabled = false
                            //self.addfriendBTN.titleLabel?.text = "Cancel Request"
                            self.addfriendBTN.setTitle("Cancel Request", for: .normal)
                            
                            //self.addfriendBTN.titleLabel?.textColor = UIColor.red
                            self.addfriendBTN.backgroundColor = UIColor.gray
                            
                            
                        }
                    })
                    
                }
            }
            
        }
        //-----Cancel Request-----
        if (currentState == "reqSent") {
            friendRequestDatabase.child(myUID).child(otherUID).removeValue { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.friendRequestDatabase.child(otherUID).child(myUID).removeValue(completionBlock: { (error, ref) in
                        self.currentState = "notFriends"
                        //self.addfriendBTN.isEnabled = true
                        self.addfriendBTN.setTitle("Add Friend", for: .normal)
                        self.addfriendBTN.backgroundColor = UIColor.red
                        
                        //self.addfriendBTN.titleLabel?.textColor = UIColor.blue
                        
                    })
                }
            }
            
        }
        //----Request Received state----
        if (currentState == "reqReceived") {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let formattedDate = dateFormatter.string(from: currentDate)
            guard let myEmail = Auth.auth().currentUser?.email else {return}
            var myName = String()
            var myImageURL = String()
            
            userDatabase.child(myUID).observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                   
                     myName = dictionary["nameOfUser"] as? String ?? ""
                    myImageURL = dictionary["profileImageURL"] as? String ?? ""
                    //theUsers.append(theUser)
                }

            }
            friendDataBase.child(myUID).child(otherUID).setValue(["dateAdded": formattedDate, "UID": otherUID, "nameOfUser" : nameOfUser, "email" : email, "profileImageURL" : friendProfileImageURL]) { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.friendDataBase.child(otherUID).child(myUID).setValue(["dateAdded": formattedDate, "UID": myUID, "nameOfUser" : myName, "email" : myEmail, "profileImageURL" : myImageURL], withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error!)
                        } else {
                            self.friendRequestDatabase.child(myUID).child(otherUID).removeValue { (error, ref) in
                                if error != nil {
                                    print(error!)
                                } else {
                                    self.friendRequestDatabase.child(otherUID).child(myUID).removeValue(completionBlock: { (error, ref) in
                                        self.currentState = "friends"
                                        //self.addfriendBTN.isEnabled = true
                                        self.addfriendBTN.setTitle("Unfriend \(self.nameOfUser)?", for: .normal)
                                        self.addfriendBTN.backgroundColor = UIColor.red
                                        
                                        //self.addfriendBTN.titleLabel?.textColor = UIColor.blue
                                        
                                    })
                                }
                            }
                            
                        }
                    })
                }
            }
        }
        
        //dismiss(animated: true, completion: nil)
        
    }
    
}

extension DetailViewController {
    
}
