//
//  FriendsViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-06-19.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import EmptyDataSet_Swift

class Friend: NSObject {
    var name: String?
    var profileImageName: String?
}
class TheMessage: NSObject{
    var text: String?
    var date: NSDate?
    
    var friend: Friend?
}
//showChatLogController
//showMessageVC
class FriendsChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, EmptyDataSetSource, EmptyDataSetDelegate {
    private let cellID = "cellID"
    var theMessages: [TheMessage]?
    var myMessages: [Message] = [Message]()
    var users = [Users]()
    var recepient = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = UIColor.white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        navigationItem.title = "Messages"
        retrieveMessages()


    }
    func retrieveMessages() {

        if let otherUID = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(otherUID).child("Messages").queryLimited(toLast: 1)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                for chatLogMessages in snapshot.children.allObjects as! [DataSnapshot] {
                    if let dictionary = chatLogMessages.value as? [String: AnyObject] {
                        let message = Message()
                        message.messageBody = dictionary["MessageBody"] as? String ?? ""
                        message.recepient = dictionary["Recepient"] as? String ?? ""
                        message.date = dictionary["timestamp"] as? Double

                        self.myMessages.append(message)
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return myMessages.count
        //return lastMessage.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell

        let message = myMessages[indexPath.row]
        
        cell.message = message
            
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    var friendProfileViewController: FriendsProfileViewController?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMessageVC", sender: self)
        //print(myMessages[indexPath.row].recepient)
        let friendMessageVC = FriendMessageCollectionViewController()
        //friendMessageVC.recepient = myMessages[indexPath.row].recepient
//        let user = self.myMessages[indexPath.row]
//        print(user.sender)
//        dismiss(animated: true) {
//            print("Dismiss Completed")
//            let user = self.myMessages[indexPath.row]
//            self.friendProfileViewController?.showMessageControllerForUser(user: user)
//            //self.showMessageControllerForUser(user: user)
//        }
    }


}

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    

    var message: Message? {

        didSet {
            nameLabel.text = message?.recepient
            
            messageLabel.text = message?.messageBody
            
            
            
            if let date = message?.date {
                let x = date / 1000
                let theDate = NSDate(timeIntervalSince1970: x)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let elapsedTimeInSeconds = NSDate().timeIntervalSince(theDate as Date)
                
                let secondsInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > secondsInDays {
                    dateFormatter.dateFormat = "EEE"
                }
//
                timeLabel.text = dateFormatter.string(from: theDate as Date)
//                
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Omar Tehsin"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friends message saying blah blah blah"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:10 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        
        setUpContainerView()
        
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "defaultUser")
        hasReadImageView.image = UIImage(named: "defaultUser")
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
        
    }
    private func setUpContainerView() {
        let containerView = UIView()
        
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: timeLabel)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        backgroundColor = UIColor.blue
        
    }
}

extension FriendsChatViewController {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let noCircle = UIImage(named: "noCircle")
        return noCircle
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title = "You have no chats!"
        let font = UIFont.boldSystemFont(ofSize: 18)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 1
        
        let attributes: [NSAttributedString.Key : Any] = [.font : font, .foregroundColor: UIColor.darkGray, .shadow: shadow]
        let attributedQuote = NSAttributedString(string: title, attributes: attributes)
        return attributedQuote
    }
}


