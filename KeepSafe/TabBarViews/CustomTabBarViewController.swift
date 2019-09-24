//
//  CustomTabBarViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBarViewController: UITabBarController {
    
    let SOSButton = UIButton(frame: CGRect.zero)
    var friendDataBase = FirebaseConstants.friendDataBase
    var SOSDatabase = FirebaseConstants.SOSDatabase
    var friendsUIDArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpSOSButton()
    }
    
    func setUpSOSButton() {
        SOSButton.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        var SOSButtonFrame = SOSButton.frame
        SOSButtonFrame.origin.y = self.view.bounds.height - SOSButtonFrame.height
        SOSButtonFrame.origin.x = self.view.bounds.width/2 - SOSButtonFrame.size.width/2
        SOSButton.frame = SOSButtonFrame
        SOSButton.backgroundColor = .orange
        SOSButton.layer.cornerRadius = SOSButtonFrame.height / 2
        SOSButton.setTitle("SOS", for: .normal)
        SOSButton.addTarget(self, action: #selector(sosPressed), for: .touchUpInside)
        self.view.addSubview(SOSButton)
        self.view.layoutIfNeeded()
        
    }
    @objc func sosPressed() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        guard let myEmail = Auth.auth().currentUser?.email else {return}
        friendDataBase.child(myUID).observe(.value) { (snapshot) in
            for friendsUID in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = friendsUID.value as? [String: AnyObject] {
                    let uid = dictionary["UID"] as? String ?? ""
                    let nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                    self.friendsUIDArray.append(uid)
                    //self.tappedSOSButtonDelegate.didTapSOSButton(friendID: self.friendsUIDArray)
                    let SOSMessageDictionary: NSDictionary = ["sender": myEmail, "SOSMessage": "SOS PLEASE HELP!", "toID": uid, "nameOfUser": nameOfUser]
                    self.SOSDatabase.childByAutoId().setValue(SOSMessageDictionary, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error)
                        } else {
                            print("SOS Sent Successfull \(uid)")
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        SOSButton.frame.origin.y = self.view.bounds.height - SOSButton.frame.height - self.view.safeAreaInsets.bottom
    }
}
