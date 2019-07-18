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


class HomePageViewController: UIViewController{
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sideMenuView: UIView!
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0

    var sideMenuOpen = false
    
    let locationVC = LocationServicesViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //barButtonItem()
        //createTabBarController()

        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)



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




