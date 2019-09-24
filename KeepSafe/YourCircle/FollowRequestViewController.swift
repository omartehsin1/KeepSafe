//
//  FollowRequestViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-30.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class FollowRequestViewController: UIViewController {
    var friendRequestDatabase = FirebaseConstants.friendRequestDatabase
    var userDatabase = FirebaseConstants.userDatabase
    var users = [Users]()
    var followUID = [String]()
    

    @IBOutlet weak var followRequestTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        followRequestTableView.delegate = self
        followRequestTableView.dataSource = self
        navigationItem.title = "Follow Request"
        // Do any additional setup after loading the view.
        fetchRequestUsers()
    }
    
    func fetchRequestUsers() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}

        friendRequestDatabase.child(myUID).observe(.childAdded) { (snapshot) in
            //print(snapshot.key)
            let theUID = snapshot.key
            self.searchByUid(uid: theUID)
            
        }

        
    }
    
    func searchByUid(uid: String) {
        userDatabase.child(uid).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = Users()
                
                user.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                user.userID = dictionary["uid"] as? String ?? ""
                
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.followRequestTableView.reloadData()
                }
            }

            
        }
    }


}

extension FollowRequestViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let followRequestCell = UITableViewCell(style: .subtitle, reuseIdentifier: "followRequestCell")
        let user = users[indexPath.row]
        followRequestCell.textLabel?.text = user.nameOfUser
        followRequestCell.detailTextLabel?.text = user.email
        
        followRequestCell.imageView?.image = UIImage(named: "defaultUser")
        followRequestCell.imageView?.layer.cornerRadius = (followRequestCell.imageView?.bounds.height)! / 2
        followRequestCell.imageView?.clipsToBounds = true
        
        followRequestCell.imageView?.contentMode = .scaleAspectFill
        
        if let profileImageURL = user.profileImageURL {
            //friendCell.imageView?.loadImageUsingCache(urlString: profileImageURL)
            followRequestCell.imageView?.layer.cornerRadius = (followRequestCell.imageView?.bounds.height)! / 2
            followRequestCell.imageView?.clipsToBounds = true
            
            //TO DO: CACHE IMAGE!
            
            
            let url = URL(string: profileImageURL)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    
                    followRequestCell.imageView?.image = UIImage(data: data!)
                    //followRequestCell.imageView?.loadImageUsingCache(urlString: profileImageURL)
                    followRequestCell.imageView?.layer.cornerRadius = (followRequestCell.imageView?.bounds.height)! / 2
                    followRequestCell.imageView?.clipsToBounds = true
                    
                    
                }
                
                }.resume()
        
        }
        return followRequestCell
    }
    
}

class FollowRequestCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
}
