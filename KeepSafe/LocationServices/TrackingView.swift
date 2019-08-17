//
//  TrackingView.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-14.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class TrackingView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    let cellId = "cellId"
    var users = [Users]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        friendCollectionView.register(CustomTrackingCell.self, forCellWithReuseIdentifier: cellId)
        fetchFollower()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        friendCollectionView.isScrollEnabled = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Trackingview", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    }
    func fetchFollower() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.trackingDatabase.child(myUID).observe(.childAdded) { (snapshot) in
            let theUID = snapshot.key
            self.searchByUID(uid: theUID)
            self.friendCollectionView.reloadData()
        }
    }
    
    func searchByUID(uid: String) {
        FirebaseConstants.userDatabase.child(uid).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users()
                user.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                user.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                self.users.append(user)
                DispatchQueue.main.async {
                    self.friendCollectionView.reloadData()
                }
            }

        }
    }

    @IBAction func stopBtnPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConfirmStopFollowingMe"), object: nil)
//        guard let myUID = Auth.auth().currentUser?.uid else {return}
//        let alertController = UIAlertController(title: "Stop Following?", message: "Are you sure you want the guardian to stop following you?", preferredStyle: UIAlertController.Style.alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
//            FirebaseConstants.selectedDatabase.child(myUID).removeValue()
//            FirebaseConstants.trackingDatabase.child(myUID).removeValue()
//            self.contentView.isHidden = true
//            self.friendCollectionView.reloadData()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            print("Cancel")
//        }
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
    }
    
}
extension TrackingView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = friendCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomTrackingCell
        let user = users[indexPath.row]
        cell.textLabel.text = user.nameOfUser
        if let profileImageURL = user.profileImageURL {
            cell.imageView.loadImageUsingCache(urlString: profileImageURL)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    
}

class CustomTrackingCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.backgroundColor = UIColor.gray
        return image
        
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = "New Person"
        
        return label
        
    }()
    
    func setUpView() {
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
