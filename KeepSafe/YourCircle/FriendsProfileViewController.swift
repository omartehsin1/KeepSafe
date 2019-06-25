//
//  FriendsProfileViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-05-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class FriendsProfileViewController: UIViewController {
    var nameOfUser : String = "No Name"
    var email : String = "No Email"
    var profileImage = UIImage()
    var friendsUID : String = ""
    var friendProfileImageURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

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
