//
//  MessageViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-13.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    /*TODO: ALL USERS ARE ABLE TO SEE MESSAGES. FIX THIS*/
    var messageArray : [Message] = [Message]()
    var users = [Users]()
    var databaseRef : DatabaseReference!
    var recepient = String()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    
    var topButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        messageTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        configureTableView()
        retrieveMessage()
        
        messageTableView.separatorStyle = .none
        
        
    }
    
    //MARK: Table view Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        //TODO: CHANGE TO USER IMAGE
        cell.avatarImageView.image = UIImage(named: "defaultUser")
        
        //Set background as blue if message is from logged in User
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.avatarImageView.backgroundColor = UIColor.flatMint() //change to flat.mint
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue() // flatSkyBlue
            
        }
            //Set background as grey if message is from another user
            
        else  {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon() //flatWatermelon
            cell.messageBackground.backgroundColor = UIColor.flatGray() // flatgrey
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
    }
    
    
    //MARK: Textfield Methods:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    //MARK: Send Button Action:
    @IBAction func sendPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
                let myUID = Auth.auth().currentUser?.uid
        
                let messageDB = Database.database().reference().child("users").child(myUID!).child("Messages").childByAutoId()
        
                let messageDictionary : NSDictionary = ["Sender" : Auth.auth().currentUser?.email as! String, "MessageBody": messageTextField.text!, "Recepient": recepient]
 
                messageDB.setValue(messageDictionary) {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        print("Message Saved Successfully!")
                    }
                    DispatchQueue.main.async {
                        self.messageTextField.isEnabled = true
                        self.sendButton.isEnabled = true
                        self.messageTextField.text = ""
                    }
                }
        

    }
    
    
    //MARK: Retrieve messages
    func retrieveMessage() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).child("Messages").observe(.value) { (snapshot) in
                for messages in snapshot.children.allObjects as! [DataSnapshot] {
                    if let dictionary = messages.value as? [String: AnyObject] {
                        let message = Message()
                        message.messageBody = dictionary["MessageBody"] as? String ?? ""
                        message.sender = dictionary["Sender"] as? String ?? ""
                        message.recepient = dictionary["Recepient"] as? String ?? ""
                        self.messageArray.append(message)
                        DispatchQueue.main.async {
                            self.configureTableView()
                            self.messageTableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    
    
}
