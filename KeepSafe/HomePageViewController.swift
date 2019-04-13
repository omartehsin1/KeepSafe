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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barButtonItem()
        menuItems = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func createArray() -> [MenuItems] {
        var tempMenuItems: [MenuItems] = []
        
        let menuItem1 = MenuItems(image: UIImage(named: "message")!, title: "Message")
        let menuItem2 = MenuItems(image: UIImage(named: "location")!, title: "Location Services")
        let menuItem3 = MenuItems(image: UIImage(named: "circle")!, title: "Your Circle")
        let menuItem4 = MenuItems(image: UIImage(named: "crime")!, title: "Report Crime")
        
        tempMenuItems.append(menuItem1)
        tempMenuItems.append(menuItem2)
        tempMenuItems.append(menuItem3)
        tempMenuItems.append(menuItem4)
        return tempMenuItems
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
            print("Animaltion is complete")
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
    
    func presentMenuView() {
        
    }

}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = menuItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell") as! MenuTableViewCell
        
        cell.setMenuItem(menuItems: menuItem)
        
        return cell
    }
    
}
