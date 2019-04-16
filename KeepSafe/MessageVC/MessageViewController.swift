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

    var messageArray : [Message] = [Message]()

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var messageTableView: UITableView!

    var topButton = UIButton()




    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageClass")
        messageTextField.delegate = self

        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        //messageTableView.addGestureRecognizer(tapGesture)

        messageTableView.separatorStyle = .none

    }

    //MARK: Table view Methods

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "defaultUser")
        
        //Set background as blue if message is from logged in User
        if cell.senderUsername.text == Auth.auth().currentUser?.email as! String {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            //self.heighContraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            //self.heighContraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDictionary : NSDictionary = ["Sender" : Auth.auth().currentUser?.email as! String, "MessageBody": messageTextField.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary) {
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
    
    func retrieveMessage() {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            let text = snapshotValue["MessageBody"] as! String
            let sender = snapshotValue["Sender"] as! String
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            DispatchQueue.main.async {
                self.configureTableView()
                self.messageTableView.reloadData()
            }
        }
    }
    


}
