//
//  YourCircleViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: nil)
    var users = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    
    @IBOutlet weak var friendsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        friendsTableView.tableHeaderView = searchController.searchBar
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        navigationItem.title = "Add Friends"
        
        databaseRef.child("users").queryOrdered(byChild: "nameOfUser").observe(.childAdded) { (snapshot) in
            self.users.append(snapshot.value as? NSDictionary)
            
            self.friendsTableView.insertRows(at: [IndexPath(row: self.users.count - 1, section: 0)], with: UITableView.RowAnimation.automatic)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissAddFriend(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewMemberPressed(_ sender: Any) {
        
        
//        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
//            print(snapshot)
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//               let newUser = Users()
//                newUser.email = dictionary["email"] as? String
//                newUser.nameOfUser = dictionary["nameOfUser"] as? String
//                self.users.append(newUser)
//
//                DispatchQueue.main.async {
//                    self.friendsTableView.reloadData()
//                }
//
//            }
//        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String) {
        self.filteredUsers = self.users.filter({ (users) -> Bool in
            let username = users!["nameOfUser"] as? String
            
            return(username?.lowercased().contains(searchText.lowercased()))!
        })
        friendsTableView.reloadData()
        
    }
}



extension AddFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return self.users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let friendCell = friendsTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }
        else {
            user = self.users[indexPath.row]
        }
        
        friendCell.textLabel?.text = user?["nameOfUser"] as? String
        friendCell.detailTextLabel?.text = user?["email"] as? String
//        let user = users[indexPath.row]
//        friendCell.textLabel?.text = user.nameOfUser
        
        
        
        return friendCell

    }


}

//class FriendCell : UITableViewCell {
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        <#code#>
//    }
//}
