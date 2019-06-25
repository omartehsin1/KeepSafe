//
//  YourCircleViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import Firebase
import FirebaseDatabase


class YourCircleViewController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    var addFriend = AddFriendViewController()
    var yourCircleCell = CircleCollectionViewCell()
    let dvc = DetailViewController()
    @IBOutlet weak var yourCircleCollectionView: UICollectionView!
    var nameOfFriend = String()
    var imageOfFriend = UIImage()
    var emailOfFriend = String()
    var databaseRef = Database.database().reference()
    
    
    
    var myCircle = [Users]()
    var newFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriends()
        yourCircleCollectionView.delegate = self
        yourCircleCollectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendTapped))
        yourCircleCollectionView.emptyDataSetView { (view) in
            view.titleLabelString(self.attributedTitle())
            view.image(self.imageForEmptySet())
        }
        
    }
    
    
    @objc func addFriendTapped() {
        performSegue(withIdentifier: "showAddFriend", sender: self)
        
    }
    
    
    func imageForEmptySet() -> UIImage?{
        let noCircle = UIImage(named: "noCircle")
        return noCircle
    }
    
    
    func attributedTitle() -> NSAttributedString? {
        let title = "There is noone in your circle, please press 'Add' to find friends!"
        let font = UIFont.boldSystemFont(ofSize: 18)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 1
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.darkGray, .shadow: shadow]
        let attributedQuote = NSAttributedString(string: title, attributes: attributes)
        
        return attributedQuote
    }
    
    
    func fetchFriends() {
        if let uid = Auth.auth().currentUser?.uid {
            databaseRef.child("users").child(uid).child("Friends").observe(.value) { (snapshot) in
                for friends in snapshot.children.allObjects as! [DataSnapshot] {
                    if let dictionary = friends.value as? [String: AnyObject] {
                        let users = Users()
                        users.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                        users.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                        users.userID = dictionary["otherUID"] as? String ?? ""
                        self.myCircle.append(users)
                        DispatchQueue.main.async {
                            self.yourCircleCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}





extension YourCircleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return myCircle.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        yourCircleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CircleCollectionViewCell

        let myFriendCircle = myCircle[indexPath.row]
        
        yourCircleCell.friendUserName.text = myFriendCircle.nameOfUser
        
        print(myFriendCircle.profileImageURL)
        
        if let profileImageURL = myFriendCircle.profileImageURL {
            yourCircleCell.friendProfileImage.loadImageUsingCache(urlString: profileImageURL)
        }

        return yourCircleCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriend", sender: self)
        self.yourCircleCollectionView.deselectItem(at: indexPath as IndexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFriend" {
            if let indexPath = yourCircleCollectionView.indexPathsForSelectedItems?.first {
                let friendVC = segue.destination as! FriendsProfileViewController
                let friends = myCircle[indexPath.row]
                friendVC.nameOfUser = friends.nameOfUser ?? "no name"
                friendVC.email = friends.email ?? "no email"
                friendVC.friendsUID = friends.userID ?? "no uid"
                //let url = URL(string: friends.profileImageURL!)
                //friendVC.friendProfileImageURL = friends.profileImageURL ?? ""
                //let data = try? Data(contentsOf: url!)
            }
        }
    }
    

    
    
}

