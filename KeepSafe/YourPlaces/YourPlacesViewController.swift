//
//  YourPlacesViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-09-23.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class YourPlacesViewController: UIViewController {

    @IBOutlet weak var addNewPlaceBTN: UIButton!
    @IBOutlet weak var yourPlacesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Places"

        // Do any additional setup after loading the view.
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
