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
    
    var databaseRef : DatabaseReference!
    

    
    //NEW VARS:
    var users = Users()
    var otherUser: NSDictionary?
    var loggedInUserData: NSDictionary?
    var newDatabaseRef: DatabaseReference?
    //END NEW VARS
    @IBOutlet weak var addfriendBTN: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseRef = Database.database().reference()
        nameOfUserLabel.text = nameOfUser
        emailLabel.text = email
        profileImageView.image = profileImage

      
    }
    

    
    @IBAction func addFriendBTNPressed(_ sender: Any) {
        let myUID = Auth.auth().currentUser?.uid
        let otherUID = friendsUID
        let thisUsersFollowerUID = self.databaseRef.child("users").child(myUID!).child("Friends").childByAutoId()
        thisUsersFollowerUID.setValue(["otherUID": otherUID, "nameOfUser" : nameOfUser, "email" : email])
        
        performSegue(withIdentifier: "friendAdded", sender: self)
        dismiss(animated: true, completion: nil)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let yourCirclevc = segue.destination as? YourCircleViewController, segue.identifier == "friendAdded" {
            //yourCirclevc.loadViewIfNeeded()
            yourCirclevc.transferUsername(username: nameOfUser)
        }
    }
    
    
    
    func btnPressed(image: UIImage) {
        
    }
    
    func addFriends() {
//        let uid = Auth.auth().currentUser?.uid
//        let ref = Database.database().reference()
//        let key = ref.child("users").childByAutoId().key
//        
//        var isFollower = false
//        
//            databaseRef.child("users").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
//            if let following = snapshot.value as? [String : AnyObject] {
//                for (ke, value) in following {
//                    if value as? String == self.users.userID {
//                        isFollower = true
//                        
//                        ref.child("users").child(uid!).child("following/\(ke)").removeValue()
//                        ref.child("users").child(self.users.userID).child("followers/\(ke)").removeValue()
//                        print("You are now following this user")
//                    }
//                }
//            }
//            
//            if !isFollower {
//                let following = ["following/\(key)": self.users.userID]
//                let followers = ["followers/\(key)": uid]
//                
//                ref.child("users").child(uid!).updateChildValues(following)
//                //ref.child("users").child(self.users.userID).updateChildValues(followers)
//                print("You are now following this user")
//                
//            }
//        }
//        ref.removeAllObservers()
//
    }

}
