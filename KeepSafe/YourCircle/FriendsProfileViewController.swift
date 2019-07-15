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
    let privacyView = UIView()
    var currentState = String()
    var friendRequestDatabase = FirebaseConstants.friendRequestDatabase
    var friendDataBase = FirebaseConstants.friendDataBase
    var userDatabase = FirebaseConstants.userDatabase
    
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var addFriendBTN: UIButton!
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = nameOfUser
        emailLabel.text = email
        profileImageView.image = profileImage
        currentState = "notFriends"
        fetchUserProfile()
        friendsOrNot()
        view.addSubview(privacyView)
        //blurEffect()
        createPrivacyView()
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
            self.privacyView.isHidden = true
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
            friendDataBase.child(myUID).child(otherUID).setValue(["dateAdded": formattedDate, "UID": otherUID, "nameOfUser" : nameOfUser, "email" : email, "profileImageURL" : friendProfileImageURL, "currentState" : "friends"]) { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.friendDataBase.child(otherUID).child(myUID).setValue(["dateAdded": formattedDate, "UID": myUID, "nameOfUser" : myName, "email" : myEmail, "profileImageURL" : myImageURL, "currentState" : "friends"], withCompletionBlock: { (error, ref) in
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
        if (currentState == "friends") {
            privacyView.isHidden = true
            friendDataBase.child(myUID).child(otherUID).removeValue { (error, ref) in
                if error != nil {
                    print(error!)
                } else {
                    self.friendDataBase.child(otherUID).child(myUID).removeValue(completionBlock: { (error, ref) in
                        self.currentState = "notFriends"
                        self.addFriendBTN.setTitle("Add Friend", for: .normal)
                        self.addFriendBTN.backgroundColor = UIColor.red
                        self.privacyView.isHidden = false
                    })
                }
            }
        }
        
    }
    func friendsOrNot() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        friendDataBase.child(myUID).observe(.value) { (snapshot) in
            if(snapshot.hasChild(self.friendsUID)) {
                let friends: String = snapshot.childSnapshot(forPath: self.friendsUID).childSnapshot(forPath: "currentState").value as! String
                
                if(friends == "friends") {
                    self.privacyView.isHidden = true
                    self.addFriendBTN.setTitle("Unfriend \(self.nameOfUser)?", for: .normal)
                }
            }
        }
        //currentState = "friends"
    }
    
    
    func fetchUserProfile() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        friendRequestDatabase.child(myUID).observeSingleEvent(of: .value) { (snapshot) in
            //print(snapshot)
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "friendMessageCollectionViewController")
//        //self.present(controller, animated: true, completion: nil)

        self.navigationController?.pushViewController(controller, animated: true)
        //performSegue(withIdentifier: "messageFriend", sender: self)
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
    
    func blurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = privacyView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        privacyView.addSubview(blurEffectView)
    }
    

}

extension FriendsProfileViewController {

    func createPrivacyView() {
        privacyView.frame = CGRect(x: 0, y: 200, width: 375, height: 467)
        privacyView.backgroundColor = UIColor.red
        view.addSubview(privacyView)
        
        privacyView.translatesAutoresizingMaskIntoConstraints = false
        [privacyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         privacyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         privacyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         privacyView.heightAnchor.constraint(equalToConstant: 467)
            ].forEach {$0.isActive = true}
        
    }
}
