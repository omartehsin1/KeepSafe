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

    @IBOutlet weak var yourCircleCollectionView: UICollectionView!
    
    let myCircle = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yourCircleCollectionView.emptyDataSetSource = self
        yourCircleCollectionView.emptyDataSetDelegate = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendTapped))

    }
    
    @objc func addFriendTapped() {
        performSegue(withIdentifier: "showAddFriend", sender: self)

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

}

extension YourCircleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myCircle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        yourCircleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CircleCollectionViewCell
//        collectionViewCell.circleLabel.text = theArray[indexPath.item]
        
        return yourCircleCell
    }
    
    
}
