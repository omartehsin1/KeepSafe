//
//  LocationServicesViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import Alamofire
import SwiftyJSON




class LocationServicesViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var userCurrentLocation : GMSMarker?
    var userImage: UIImage?
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    var crimeLocation = [CLLocationCoordinate2D]()
    var friendDataBase = FirebaseConstants.friendDataBase
    var SOSDatabase = FirebaseConstants.SOSDatabase
    var friendsUIDArray = [String]()
    var sideMenuOpen = false
    var coordinateLoc: CLLocationCoordinate2D!

    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //createTabBarController()
        //api key: AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        GMSServices.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        GMSPlacesClient.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        
        let camera = GMSCameraPosition.camera(withLatitude: 43.6789923, longitude: -79.3120105, zoom: 17)

        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
 
        
        let currentLocation = CLLocationCoordinate2DMake(43.6789923, -79.3120105)
        //let crimeLocation = CLLocationCoordinate2DMake(latitude, longitude)
        
        //let marker = GMSMarker(position: currentLocation)
        //marker.title = "Current Location"
        userImage = UIImage(named: "defaultUser")
        //marker.icon = resizeImage(image: userImage!, newWidth: 50)
        //marker.map = mapView
        _ = markerCreater(location: currentLocation, title: "Current Location", image: "defaultUser")


        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(buttonAction))

        createButton()
        notificationCenter()
        


    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            var welcomeViewController = WelcomeViewController()
            welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            self.present(welcomeViewController, animated: true, completion: nil)
        } catch let error {
            print("There was an error: \(error)")
        }
    }
    
    
    @IBAction func sideMenuBtnTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    
    
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.frame = CGRect(x: 0, y: 64, width: (navigationController?.view.bounds.size.width)!, height: 44)
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        view.addSubview(searchBar)
    }
    
    func markerCreater(location: CLLocationCoordinate2D, title: String, image: String) -> GMSMarker {
        let marker = GMSMarker(position: location)
        //guard let stringToImage = UIImage(named: image) else {return marker}
        marker.title = title
        marker.icon = resizeImage(image: image, newWidth: 50)
        marker.map = mapView
        return marker
    }
    
    func resizeImage(image: String, newWidth: CGFloat) -> UIImage? {
        
        guard let stringToImage = UIImage(named: image) else {return nil}
        let scale = newWidth / stringToImage.size.width
        let newHeight = stringToImage.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        stringToImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    
    
    func createButton() {
        //        let button = UIButton(frame: CGRect(x: 313, y: 584, width: 100, height: 50))
        //        button.backgroundColor = .blue
        //        button.setTitle("Query Data", for: .normal)
        //        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        let SOSButton = UIButton(frame: CGRect(x: 150, y: 490, width: 107, height: 100))
        //let SOSButton = UIButton()

        SOSButton.layer.cornerRadius = 50
        SOSButton.layer.masksToBounds = true
        
        SOSButton.backgroundColor = .orange
        SOSButton.setTitle("SOS", for: .normal)
        SOSButton.addTarget(self, action: #selector(sosPressed), for: .touchUpInside)

        self.view.addSubview(SOSButton)
    }
    @objc func sosPressed() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        guard let myEmail = Auth.auth().currentUser?.email else {return}

        friendDataBase.child(myUID).observe(.value) { (snapshot) in
            for friendsUID in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = friendsUID.value as? [String: AnyObject] {
                    
                    let uid = dictionary["UID"] as? String ?? ""
                    let nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                    self.friendsUIDArray.append(uid)
                    
                    
                    //self.tappedSOSButtonDelegate.didTapSOSButton(friendID: self.friendsUIDArray)
                    let SOSMessageDictionary: NSDictionary = ["sender": myEmail, "SOSMessage": "SOS PLEASE HELP!", "toID": uid, "nameOfUser": nameOfUser]
                    self.SOSDatabase.childByAutoId().setValue(SOSMessageDictionary, withCompletionBlock: { (error, ref) in
                        if error != nil {
                            print(error)
                        } else {
                            print("SOS Sent Successfull \(uid)")
                        }
                    })
                    
                }
                
            }

//
//            for friendsUID in self.friendsUIDArray {
//                print(friendsUID)
//
//
//            }
            
            
//            let messageCollectionVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendChatViewController") as! FriendsChatViewController
//
//            messageCollectionVC.friendsUID = self.friendsUIDArray
//            self.navigationController?.pushViewController(messageCollectionVC, animated: true)

        }
        
        
        
        
        
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is FriendMessageCollectionViewController {
//            let messageController = segue.destination as? FriendMessageCollectionViewController
//            messageController?.friendsUID = friendsUIDArray
//        }
//    }
    @objc func buttonAction() {
        //performSegue(withIdentifier: "showCrimeFilter", sender: self)
        let crimeVC = storyboard?.instantiateViewController(withIdentifier: "CrimeFilter") as! CrimeFilterViewController
        //let crimeVC = CrimeFilterViewController()
        crimeVC.passCoordinateBackDelegate = self
        self.navigationController?.pushViewController(crimeVC, animated: true)
    }
    

}

extension LocationServicesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        coordinateLoc = locValue
    }
}

extension LocationServicesViewController: PassCoordinatesBack {
    func didTapSearch(coordinates: [CLLocationCoordinate2D], kindofCrime: String, date: [String]) {
        var theDate = String()
        for dates in date {
            theDate = dates
        }
        for crimeCoordinates in coordinates {
            _ = self.markerCreater(location: crimeCoordinates, title: theDate, image: kindofCrime)


        }
        
        
    }

    
}

extension LocationServicesViewController {
    func notificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name("ShowProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMessages), name: NSNotification.Name("ShowMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showYourCircle), name: NSNotification.Name("ShowYourCircle"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(showReportCrime), name: NSNotification.Name("ShowReportCrime"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(showPlaces), name: NSNotification.Name("ShowPlaces"), object: nil)

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
//    @objc func showReportCrime() {
//        performSegue(withIdentifier: "ShowReportCrime", sender: nil)
//        
//    }
//    @objc func showPlaces() {
//        performSegue(withIdentifier: "ShowPlaces", sender: nil)
//        
//    }

}


