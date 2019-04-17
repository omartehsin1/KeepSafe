//
//  HomePageViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-12.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomePageViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerMenuIsVisible = false
    var menuItems: [MenuItems] = []
    var profileItems: [ProfileItems] = []
    var combinedArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barButtonItem()
        menuItems = createArray()

        profileItems = createProfileArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //combinedArray = [menuItems.count + profileItems.count]

        // Do any additional setup after loading the view.
    }
    
    func createArray() -> [MenuItems] {
        var tempMenuItems: [MenuItems] = []

        let menuItems1 = MenuItems(image: UIImage(named: "message")!, title: "message")
        let menuItem2 = MenuItems(image: UIImage(named: "message")!, title: "Message")
        let menuItem3 = MenuItems(image: UIImage(named: "location")!, title: "Location Services")
        let menuItem4 = MenuItems(image: UIImage(named: "circle")!, title: "Your Circle")
        let menuItem5 = MenuItems(image: UIImage(named: "crime")!, title: "Report Crime")
        let menuItem6 = MenuItems(image: UIImage(named: "places")!, title: "Places")
        
        tempMenuItems.append(menuItems1)
        tempMenuItems.append(menuItem2)
        tempMenuItems.append(menuItem3)
        tempMenuItems.append(menuItem4)
        tempMenuItems.append(menuItem5)
        tempMenuItems.append(menuItem6)
        
        //combinedArray.append(contentsOf: tempMenuItems)

        return tempMenuItems

    }
    
    func createProfileArray() -> [ProfileItems] {
        var tempProfileItems: [ProfileItems] = []

        let profileItem = ProfileItems(profileImage: UIImage(named: "defaultUser")!, nameTitle: "Omar Tehsin", location: "Toronto")

        tempProfileItems.append(profileItem)

        //combinedArray.append(contentsOf: tempProfileItems)

        return tempProfileItems
    }
    
    func barButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
    }
    @IBAction func hamburgerBtnTapped(_ sender: Any) {
        
        if !hamburgerMenuIsVisible {
            leadingC.constant = 250
            //trailingC.constant = -150
            hamburgerMenuIsVisible = true
        } else {
            leadingC.constant = 0
            trailingC.constant = 0
            
            hamburgerMenuIsVisible = false
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("Animation is complete")
        }
    }
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
            var welcomeViewController = WelcomeViewController()
            welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.present(welcomeViewController, animated: true, completion: nil)
        } catch let error {
            print("There was an error: \(error)")
        }
        
    }


}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuItems.count
//        return 6

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row == 0) {
            let profileItem = profileItems[indexPath.row]

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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            return 115
        }
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 0) {
            performSegue(withIdentifier: "showProfileVC", sender: self)
        }
        
        if (indexPath.row == 1) {
            performSegue(withIdentifier: "showMessageVc", sender: self)
        }
        
        else if (indexPath.row == 2) {
            performSegue(withIdentifier: "showLocationServiceVC", sender: self)
        }
        
        else if (indexPath.row == 3) {
            performSegue(withIdentifier: "showYourCircleVC", sender: self)
        }
    }
    
}
