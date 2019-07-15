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
import GoogleMaps
import GooglePlaces

class HomePageViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sideMenuView: UIView!
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    
    
    var username : String = "No Name"
    var userImageURL = String()
    var randomImage = UIImageView()
    var email = String()
    var firstName = String()
    var lastName = String()
    var phoneNumber = String()
    var friendDataBase = FirebaseConstants.friendDataBase
    var userDatabase = FirebaseConstants.userDatabase
    var hamburgerMenuIsVisible = false
    var sideMenuOpen = false
    var menuItems: [MenuItems] = []
    var profileItems: [ProfileItems] = []
    var combinedArray: [Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barButtonItem()
        //menuItems = createArray()

        //profileItems = createProfileArray()
        
        


        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMessages), name: NSNotification.Name("ShowMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showYourCircle), name: NSNotification.Name("ShowYourCircle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showReportCrime), name: NSNotification.Name("ShowReportCrime"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPlaces), name: NSNotification.Name("ShowPlaces"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name("ShowProfile"), object: nil)

    }
    
    func layoutView() {
        sideMenuView.layer.backgroundColor = UIColor.clear.cgColor
        sideMenuView.layer.shadowColor = UIColor.black.cgColor
        sideMenuView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        sideMenuView.layer.shadowOpacity = 1
        sideMenuView.layer.shadowRadius = 10
        sideMenuView.clipsToBounds = false
        sideMenuView.layer.shadowPath = UIBezierPath(roundedRect: sideMenuView.bounds, cornerRadius: 10).cgPath
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        
        sideMenuView.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        

        
    }
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = -240
        } else {
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }


    
    func barButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogOut))
    }
    @IBAction func hamburgerBtnTapped(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
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
    
    @objc func showProfile() {
        performSegue(withIdentifier: "ShowProfile", sender: nil)
        
    }
    
    @objc func showMessages() {
        performSegue(withIdentifier: "ShowMessages", sender: nil)
        
    }
    @objc func showYourCircle() {
        performSegue(withIdentifier: "ShowYourCircle", sender: nil)
        
    }
    @objc func showReportCrime() {
        performSegue(withIdentifier: "ShowReportCrime", sender: nil)
        
    }
    @objc func showPlaces() {
        performSegue(withIdentifier: "ShowPlaces", sender: nil)
        
    }


}




