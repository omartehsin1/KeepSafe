//
//  FriendsProfileViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-05-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class FriendsProfileViewController: UIViewController {
    var nameOfUser : String = "No Name"
    var email : String = "No Email"
    var profileImage = UIImage()
    var friendsUID : String = ""
    var friendProfileImageURL: String = ""
    
    var currentState = "notFriends"
    var friendRequestDatabase = Database.database().reference().child("friendReq")
    var friendDataBase = Database.database().reference().child("friends")
    var userDatabase = Database.database().reference().child("users")
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var addFriendBTN: UIButton!
    
    @IBOutlet weak var privacyView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameOfUser
        emailLabel.text = email
        profileImageView.image = profileImage
        currentState = "notFriends"
        fetchUserProfile()
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
                            self.addFriendBTN.setTitle("Cancel Request", for: .normal)
                            
                            //self.addfriendBTN.titleLabel?.textColor = UIColor.red
                            self.addFriendBTN.backgroundColor = UIColor.gray
                            
                            
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
                        self.addFriendBTN.setTitle("Add Friend", for: .normal)
                        self.addFriendBTN.backgroundColor = UIColor.red
                        
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
                                        self.addFriendBTN.setTitle("Unfriend \(self.nameOfUser)?", for: .normal)
                                        self.addFriendBTN.backgroundColor = UIColor.red
                                        
                                        //self.addfriendBTN.titleLabel?.textColor = UIColor.blue
                                        
                                    })
                                }
                            }
                            
                        }
                    })
                }
            }
        }
        
        
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
                    self.addFriendBTN.setTitle("Accept Friend Request", for: .normal)
                    //                    self.declineFriendBTN.isHidden = false
                    //                    self.declineFriendBTN.isEnabled = true
                    
                    
                } else if (reqType == "sent") {
                    self.currentState = "reqSent"
                    //self.addfriendBTN.isEnabled = true
                    self.addFriendBTN.setTitle("Cancel Friend Request", for: .normal)
                    //                    self.declineFriendBTN.isHidden = true
                    //                    self.declineFriendBTN.isEnabled = false
                }
            }
        }
    }

    
    @IBAction func chatBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "messageFriend", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageFriend" {
            let friendChatMessage = segue.destination as! FriendMessageCollectionViewController
            
            friendChatMessage.recepient = nameOfUser
            friendChatMessage.toID = friendsUID

        }
    }
    func showMessageControllerForUser(user: Message) {
        let friendMessageControler = FriendMessageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        navigationController?.present(friendMessageControler, animated: true, completion: nil)
    }
    

}
