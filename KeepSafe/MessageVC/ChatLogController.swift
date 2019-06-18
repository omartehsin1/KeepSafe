//
//  ChatLogController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-30.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import Firebase

class ChatLogController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    @IBOutlet weak var chatLogtableView: UITableView!
    var myMessages: [Message] = [Message]()
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        chatLogtableView.delegate = self
        chatLogtableView.dataSource = self
        chatLogtableView.register(UINib(nibName: "ChatLogTableViewCell", bundle: nil), forCellReuseIdentifier: "chatLogCell")
        
        chatLogtableView.emptyDataSetSource = self
        chatLogtableView.emptyDataSetDelegate = self
        
        retrieveMessages()
        barButtonItem()
    }
    
    func barButtonItem() {
        navigationItem.title = "Compose Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeMessage))
    }
    
    @objc func composeMessage() {
        
    }
    
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
    func retrieveMessages() {
        if let uid = Auth.auth().currentUser?.uid {
            
            Database.database().reference().child("users").child(uid).child("Messages").observe(.value) { (snapshot) in
                
                for chatLogMessages in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if let dictionary = chatLogMessages.value as? [String: AnyObject] {
                        let message = Message()
                        message.messageBody = dictionary["MessageBody"] as? String ?? ""
                        message.recepient = dictionary["Recepient"] as? String ?? ""
                        self.myMessages.append(message)
                        DispatchQueue.main.async {
                            self.chatLogtableView.reloadData()
                        }
                    }
                }
                
            }
        }
 
    }
    
}

extension ChatLogController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = chatLogtableView.dequeueReusableCell(withIdentifier: "chatLogCell", for: indexPath) as! ChatLogTableViewCell
        chatCell.userNameLabel.text = myMessages[indexPath.row].recepient
        
        chatCell.userImageview.image = UIImage(named: "defaultUser")
        
        return chatCell
    }
    
    
}
