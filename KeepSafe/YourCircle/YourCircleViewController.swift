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
                        let name = dictionary["nameOfUser"] as? String ?? ""
                        self.newFriends.append(name)
                        print(name)
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
        print(newFriends.count)
        return newFriends.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        yourCircleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CircleCollectionViewCell
        yourCircleCell.friendUserName.text = newFriends[indexPath.row]
        //        print("the user name is: \(myFriendCircle)")
        
        
        
        
        //let myFriendCircle = myCircle[indexPath.row]
        //yourCircleCell.friendUserName.text = myCircle[indexPath.row].nameOfUser
        //print("the username is :\(myFriendCircle.nameOfUser)")
        
        
        return yourCircleCell
    }
    
    
    
    
}

