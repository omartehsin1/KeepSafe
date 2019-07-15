//
//  SideMenuVC.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-14.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase


class SideMenuVC: UIViewController {
    @IBOutlet var sideMenuTableView: UITableView!
    var menuItems: [MenuItems] = []
    var profileItems: [ProfileItems] = []
    var userDatabase = FirebaseConstants.userDatabase
    var username : String = "No Name"
    var userImageURL = String()
    var randomImage = UIImageView()
    var email = String()
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        menuItems = createMenuArray()
        profileItems = createProfileArray()
        

        
        
    }
    

    
    func createMenuArray() -> [MenuItems] {
        var tempMenuItems: [MenuItems] = []
        let menuItems1 = MenuItems(image: UIImage(named: "message")!, title: "message")
        let menuItem2 = MenuItems(image: UIImage(named: "message")!, title: "Message")
        let menuItem3 = MenuItems(image: UIImage(named: "circle")!, title: "Your Circle")
        let menuItem4 = MenuItems(image: UIImage(named: "crime")!, title: "Report Crime")
        let menuItem5 = MenuItems(image: UIImage(named: "places")!, title: "Places")
        
        tempMenuItems.append(menuItems1)
        tempMenuItems.append(menuItem2)
        tempMenuItems.append(menuItem3)
        tempMenuItems.append(menuItem4)
        tempMenuItems.append(menuItem5)
        
        return tempMenuItems
    }
    
    func createProfileArray() -> [ProfileItems] {
        var tempProfileItems: [ProfileItems] = []
        
        let profileItem = ProfileItems(profileImage: randomImage, theUsername: username, location: "Toronto", email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        tempProfileItems.append(profileItem)
        
        
        return tempProfileItems
    }
    
    func loadUserName(completion: @escaping(_ username: String) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if let nameOfUser = dictionary["nameOfUser"] as? String {
                        self.username = nameOfUser
                        //print("The name of the user is \(self.username)")
                        completion(self.username)
                    }
                }
            }
        }
    }
    
    
    
    
    func loadProfileImageView(completion: @escaping(_ userImageURL: String) -> Void) {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        userDatabase.child(myUID).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //let user = Users()
                let imageUrl = dictionary["profileImageURL"] as? String ?? ""
                self.userImageURL = imageUrl
                completion(self.userImageURL)
                
            }
        }
    }

    
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let profileItem = profileItems[indexPath.row]
            //profileItem.nameTitle = profileItem[indexPath.row]
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
            
            profileCell.setProfileItem(profileItems: profileItem)
            
            return profileCell
        } else if (indexPath.row >= 1){
            let menuItem = menuItems[indexPath.row]
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! MenuTableViewCell
            
            
            cell.setMenuItem(menuItems: menuItem)
            
            return cell
        }
        
        
        
        return UITableViewCell()
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowMessages"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("ShowYourCircle"), object: nil)
//        case 3:
//            NotificationCenter.default.post(name: NSNotification.Name("ShowPlaces"), object: nil)
//        case 4:
//            NotificationCenter.default.post(name: NSNotification.Name("ShowYourCircle"), object: nil)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return 115
        }
        
        return 90
    }
    
    
}
