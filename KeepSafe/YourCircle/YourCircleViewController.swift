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
        //fetchFriends()
        print("friends name is: \(nameOfFriend)")
        //print("myCircle is: \(myCircle)")
//        yourCircleCollectionView.emptyDataSetSource = self
//        yourCircleCollectionView.emptyDataSetDelegate = self
        yourCircleCollectionView.delegate = self
        yourCircleCollectionView.dataSource = self
 
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendTapped))
        yourCircleCollectionView.emptyDataSetView { (view) in
            view.titleLabelString(self.attributedTitle())
            view.image(self.imageForEmptySet())
            
            self.databaseRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
            })
        }
        
    }
    

    @objc func addFriendTapped() {
        performSegue(withIdentifier: "showAddFriend", sender: self)

    }
    
//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        let noCircle = UIImage(named: "noCircle")
//        return noCircle
//    }
    
    func imageForEmptySet() -> UIImage?{
        let noCircle = UIImage(named: "noCircle")
        return noCircle
    }
    
//    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        let title = "There is noone in your circle, please press 'Add' to find friends!"
//        let font = UIFont.boldSystemFont(ofSize: 18)
//        let shadow = NSShadow()
//        shadow.shadowColor = UIColor.black
//        shadow.shadowBlurRadius = 1
//        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.darkGray, .shadow: shadow]
//        let attributedQuote = NSAttributedString(string: title, attributes: attributes)
//
//        return attributedQuote
//    }
    
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
    
    func transferUsername(username: String) {
        if username == nil {
            print("Username is nil")
        } else {
            nameOfFriend = username
            print("name of friend is: \(nameOfFriend)")
            let user = Users()
            user.nameOfUser = nameOfFriend
            self.myCircle.append(user)
        }
    }
    
    
    
//    func fetchFriends() {
//        databaseRef.child("users").child("Friends").queryOrderedByKey().observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String : AnyObject] {
//                let user = Users()
//                user.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
//                print("The username is: \(user.nameOfUser)")
//                print(snapshot)
//            }
//        }
//    }


}

    
    


extension YourCircleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return newFriends.count
        return myCircle.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        yourCircleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CircleCollectionViewCell
//        let myFriendCircle = newFriends[indexPath.row]
//        yourCircleCell.friendUserName.text = myFriendCircle
//        print("the user name is: \(myFriendCircle)")
        
        //let myFriendCircle = myCircle[indexPath.row]
        yourCircleCell.friendUserName.text = myCircle[indexPath.row].nameOfUser
        //print("the username is :\(myFriendCircle.nameOfUser)")
        

        return yourCircleCell
    }
    

    
    
}

