//
//  YourCircleViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class YourCircleViewController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    var addFriend = AddFriendViewController()
    var yourCircleCell = CircleCollectionViewCell()
    let dvc = DetailViewController()
    @IBOutlet weak var yourCircleCollectionView: UICollectionView!
    var nameOfFriend = String()
    var imageOfFriend = UIImage()
    var emailOfFriend = String()
//    var friendUID = String()
    
    
    var myCircle = [Users]()
    var newFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yourCircleCollectionView.emptyDataSetSource = self
        yourCircleCollectionView.emptyDataSetDelegate = self
        yourCircleCollectionView.delegate = self
        yourCircleCollectionView.dataSource = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendTapped))
        
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("view disappeared")
    }
    @objc func addFriendTapped() {
        performSegue(withIdentifier: "showAddFriend", sender: self)
        dvc.friendDelegate = self
        

    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let noCircle = UIImage(named: "noCircle")
        return noCircle
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
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
//        nameOfFriend = username
//        newFriends.append(nameOfFriend)
        if username == nil {
            print("Username is nil")
        } else {
            nameOfFriend = username
            newFriends.append(nameOfFriend)
        }
    }


}

    
    


extension YourCircleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newFriends.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        yourCircleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CircleCollectionViewCell
        let myFriendCircle = newFriends[indexPath.row]
        yourCircleCell.friendUserName.text = myFriendCircle
        

        
        return yourCircleCell
    }
    
    
}

extension YourCircleViewController: FriendAddedDelegate {
    func didAddFriend(name: String) {
        //let myFriendCircle = Users()
        //myFriendCircle.nameOfUser = name
//        nameOfFriend = name
//        self.newFriends.append(nameOfFriend)
        //self.myCircle.append(myFriendCircle)
        
        //print("On Your Circle View Controller: \(nameOfFriend)")
        //yourCircleCell.friendUserName.text = nameOfFriend
    }
    
    
}
