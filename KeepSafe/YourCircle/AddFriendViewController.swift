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
    var friendCell = UITableViewCell()
    
 
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
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {

                self.friendCell.imageView?.image = UIImage(data: data)
            }
        }
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
        
        
        friendCell = friendsTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
        
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }
        else {
            user = self.users[indexPath.row]
        }
        
        friendCell.textLabel?.text = user?["nameOfUser"] as? String
        friendCell.detailTextLabel?.text = user?["email"] as? String
        //friendCell.imageView?.image = UIImage(data: user?["profileImageURL"] as? Data)
        let profilePicURL = user?["profileImageURL"] as? String
        let theUsername = user?["nameOfUser"] as? String
        
        let storage = Storage.storage()
        var storeageRef = storage.reference()
        storeageRef = storage.reference(forURL: "https://keep-safe-1e8eb.firebaseio.com/")
        
        
        if profilePicURL == nil {
            friendCell.imageView?.image = UIImage(named: "defaultUser")
        } else {
                downloadImage(from: profilePicURL!)
            }


        return friendCell

    }


}

//class FriendCell : UITableViewCell {
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        <#code#>
//    }
//}
