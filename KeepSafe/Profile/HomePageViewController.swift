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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    var mapView: GMSMapView!
    var userCurrentLocation: GMSMarker?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
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
    var menuItems: [MenuItems] = []
    var profileItems: [ProfileItems] = []
    var combinedArray: [Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barButtonItem()
        menuItems = createArray()

        profileItems = createProfileArray()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        GMSServices.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        GMSPlacesClient.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        let camera = GMSCameraPosition.camera(withLatitude: 43.6789923, longitude: -79.3120105, zoom: 17)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        loadUserName(completion: { username in
//            self.nameOfUserLabel.text = "Welcome \(username)"
//
//        })
        
//        loadProfileImageView { (userImageURL) in
//            self.userImageView.loadImageUsingCache(urlString: userImageURL)
//        }

        

    }
    override func viewDidDisappear(_ animated: Bool) {
        leadingC.constant = 0
        trailingC.constant = 0
        
        hamburgerMenuIsVisible = false
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
        
    
//
//        let profileItem = ProfileItems(profileImage: userImageURL, nameTitle: username, location: "Toronto")
        //let profileItem = ProfileItems(profileImage: randomImage, theUsername: username, location: "Toronto")
        let profileItem = ProfileItems(profileImage: randomImage, theUsername: username, location: "Toronto", email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)

        tempProfileItems.append(profileItem)


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

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            performSegue(withIdentifier: "showChatLogController", sender: self)
        }
        
        else if (indexPath.row == 2) {
            performSegue(withIdentifier: "showLocationServiceVC", sender: self)
        }
        
        else if (indexPath.row == 3) {
            performSegue(withIdentifier: "showYourCircleVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                
                let profileSettingVC = segue.destination as! ProfileSettingViewController
                let myProfile = profileItems[indexPath.row]
                guard let myUID = Auth.auth().currentUser?.uid else {return}
                
                userDatabase.child(myUID).observe(.value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        //profileSettingVC.nameLabel.text = dictionary["firstName"] as? String ?? ""
                        //profileSettingVC.emailTextField.text = dictionary["email"] as? String ?? ""
                        //profileSettingVC.firstNameTextField.text = dictionary["firstName"] as? String ?? ""
                        profileSettingVC.lastNameTextField.text = dictionary["lastName"] as? String ?? ""
                        profileSettingVC.phoneNumberTextField.text = dictionary["phoneNumber"] as? String ?? ""
                        print(dictionary["firstName"] as? String ?? "")
                    }
                }

                
            }
            
            
        }
    }
    
}
