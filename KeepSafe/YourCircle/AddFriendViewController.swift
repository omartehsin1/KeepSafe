//
//  YourCircleViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController {

    var users = [Users]()
    
    var searchController = UISearchController()
    var resultsController = UITableViewController()

    var databaseRef = Database.database().reference()
    //var friendCell = UITableViewCell()
    
 
    @IBOutlet weak var friendsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        navigationItem.title = "Add Friends"
        
        fetchUser()
        friendsTableView.register(UserCell.self, forCellReuseIdentifier: "friendCell")

 
    }
    
    @IBAction func dismissAddFriend(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewMemberPressed(_ sender: Any) {

    }
    
    func fetchUser() {
        databaseRef.child("users").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users()
                user.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.friendsTableView.reloadData()
                }
            }
        }
        
    }

}

extension AddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let friendCell = friendsTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        let user = users[indexPath.row]
        friendCell.textLabel?.text = user.nameOfUser
        friendCell.detailTextLabel?.text = user.email
        friendCell.imageView?.image = UIImage(named: "defaultUser")
        friendCell.imageView?.layer.cornerRadius = (friendCell.imageView?.bounds.height)! / 2
        friendCell.imageView?.clipsToBounds = true
        
        friendCell.imageView?.contentMode = .scaleAspectFill
        
        if let profileImageURL = user.profileImageURL {
            let url = URL(string: profileImageURL)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {

                friendCell.imageView?.image = UIImage(data: data!)
                friendCell.imageView?.layer.cornerRadius = (friendCell.imageView?.bounds.height)! / 2
                friendCell.imageView?.clipsToBounds = true
                    
 
                }
                
                }.resume()
            
        }

        return friendCell

    }


}
class UserCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
}

