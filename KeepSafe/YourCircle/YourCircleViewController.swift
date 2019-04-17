//
//  YourCircleViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-17.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class YourCircleViewController: UIViewController {
    var addFriend = AddFriendViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendTapped))
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func addFriendTapped() {
        performSegue(withIdentifier: "showAddFriend", sender: self)
        //addFriend = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        //present(addFriend, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
