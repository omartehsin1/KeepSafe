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
    
    @IBOutlet weak var theSearchBar: UISearchBar!
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var theMapView: UIView!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var userCurrentLocation : GMSMarker?
    var userImage: UIImage?
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    var crimeLocation = [CLLocationCoordinate2D]()
    var sideMenuOpen = false
    var coordinateLoc: CLLocationCoordinate2D!
    var theLocations : CLLocation?
    let myCircleTrackingView = TrackingView()
    let guardianTrackingView = GuardianView()
     //let searchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        mapView.isMyLocationEnabled = true
        mapView.frame = CGRect(x: 0, y: 120, width: 414, height: 547)
        view.addSubview(mapView)
        theSearchBar.delegate = self
        theSearchBar.placeholder = "Search Location"
        
       //view = mapView
        

        locationManager.startUpdatingLocation()
        myCircleTrackingView.isHidden = true
        guardianTrackingView.isHidden = true

        notificationCenter()
        
        //createSearchBar()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        //createCameraButton()


        //Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.startLiveLocation), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createFriendMarker()
        myCircleTrackingViewBar()
        guardianTrackingViewBar()
    }
    
    
    func myCircleTrackingViewBar() {
        guard let navY = navigationController?.navigationBar.frame.height else {return}
        myCircleTrackingView.frame = CGRect(x: 0, y: navY, width: UIScreen.main.bounds.width, height: 100)
        view.addSubview(myCircleTrackingView)
    }
    
    func guardianTrackingViewBar() {
        guard let navY = navigationController?.navigationBar.frame.height else {return}
        guardianTrackingView.frame = CGRect(x: 0, y: navY, width: UIScreen.main.bounds.width, height: 100)
        view.addSubview(guardianTrackingView)
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

    func createCameraButton() {
        let cameraButton = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(openCamera))
        self.navigationItem.rightBarButtonItem = cameraButton
    }
    
    @objc func openCamera() {
        var cameraVC = CameraViewController()
        cameraVC = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }

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
        theLocations = locations.last
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        //self.mapView.animate(to: camera)
        //self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

        self.locationManager.stopUpdatingLocation()
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
        NotificationCenter.default.addObserver(self, selector: #selector(confirmTrackingAlert), name: NSNotification.Name("ConfirmTrackingAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showTrackingView), name: NSNotification.Name("ShowTrackingView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGuardianView), name: NSNotification.Name("ShowGuardianView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alertWolf), name: NSNotification.Name(rawValue: "AlertWolf"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(confirmStopFollowingMe), name: NSNotification.Name(rawValue: "ConfirmStopFollowingMe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(confirmStopTracking), name: NSNotification.Name(rawValue: "ConfirmStopTracking"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPlaces), name: NSNotification.Name(rawValue: "ShowPlaces"), object: nil)
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
    @objc func showPlaces() {
        performSegue(withIdentifier: "ShowPlaces", sender: nil)
        
    }
    
    @objc func showTrackingView() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.trackingDatabase.child(myUID).observe(.value) { (snapshot) in
//            if let dictionary = snapshot.value as? [String : AnyObject] {
//                print(dictionary)
//                guard let status = dictionary["status"] as? String else {return}
//                print(status)
//                if status == "tracking" {
//                    self.myCircleTrackingView.isHidden = false
//                    Alert.showTrackingConfirmation(on: self)
//                }
//            }
            if myUID == snapshot.key {
                //print(snapshot.key)
                self.myCircleTrackingView.isHidden = false
                //Alert.showTrackingConfirmation(on: self)
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    print("the dictionary is: \(dictionary)")
//                    guard let status = dictionary["status"] as? String else {return}
//                    print(status)
//                    if status == "tracking" {
//                        self.myCircleTrackingView.isHidden = false
//                        Alert.showTrackingConfirmation(on: self)
//                    }
//                }
            }
        }
        
    }
    
    @objc func showGuardianView() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        FirebaseConstants.trackingDatabase.child(myUID).observe(.value) { (snapshot) in
            
            if myUID != snapshot.key {
                print("error!")
                
            } else {
                self.guardianTrackingView.isHidden = false
            }
        }
    }

    
    @objc func confirmTrackingAlert() {
        let alertController = UIAlertController(title: "Track Location ", message: "User wants to share their location", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Pressed")
        }
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        guard let latitude = theLocations?.coordinate.latitude else {return}
        guard let longitude = theLocations?.coordinate.longitude else {return}
        
        let timestamp = ServerValue.timestamp()
        
        let liveLocationDictionary :NSDictionary = ["latitude": latitude, "longitude": longitude, "timestamp": timestamp]
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
            
            FirebaseConstants.selectedDatabase.child(myUID).observe(.value) { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    print("dictionary is: \(dictionary)")
                    guard let theFriendFollowUID = dictionary["myUID"] as? String else {return}
                    let otherLiveLocation :NSDictionary = ["latitude": latitude, "longitude": longitude, "timestamp": timestamp, "status": "tracking"]
                    let liveLocationDB = FirebaseConstants.trackingDatabase.child(theFriendFollowUID).child(myUID)
                    liveLocationDB.setValue(otherLiveLocation) { (error, ref) in
                        if error != nil {
                            print(error!)
                        } else {
                            print("Location saved successfully")
                        }
                    }
                    
                }
            }
            FirebaseConstants.selectedDatabase.child(myUID).observe(.value) { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    print("dictionary is: \(dictionary)")
                    guard let theFriendFollowUID = dictionary["myUID"] as? String else {return}
                    //friendFollowUID = theFriendFollowUID
                    let trackMeDB = FirebaseConstants.trackMeDatabase.child(myUID).child(theFriendFollowUID)
                    trackMeDB.setValue(liveLocationDictionary) { (error, ref) in
                        if error != nil {
                            print(error!)
                        } else {
                            print("Location saved successfully")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("ShowGuardianView"), object: nil)
        }
            //NotificationCenter.default.post(name: NSNotification.Name("AlertWolf"), object: nil)
            //FirebaseConstants.selectedDatabase.child(myUID).removeValue()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func alertWolf() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        print(myUID)
        FirebaseConstants.trackMeDatabase.child(myUID).observe(.value) { (snapshot) in
            if myUID == snapshot.key {
                let alertController = UIAlertController(title: "Accepted", message: "User has accepted your Follow Me Request", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (action) in
                    print("Ok")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    @objc func confirmStopFollowingMe() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let alertController = UIAlertController(title: "Stop Following?", message: "Are you sure you want the guardian to stop following you?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            //FirebaseConstants.selectedDatabase.child(myUID).removeValue()
            FirebaseConstants.trackingDatabase.child(myUID).removeValue()
            self.myCircleTrackingView.contentView.isHidden = true
            self.myCircleTrackingView.friendCollectionView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @objc func confirmStopTracking() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let alertController = UIAlertController(title: "Stop Following?", message: "Are you sure you want to stop following this user?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            //FirebaseConstants.selectedDatabase.child(myUID).removeValue()
            FirebaseConstants.trackMeDatabase.child(myUID).removeValue()
            self.guardianTrackingView.contentView.isHidden = true
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func createFriendMarker() {
        //FIND A WAY TO GET THAT SPEICIFC USERS IMAGE
        guard let myUID = Auth.auth().currentUser?.uid else {return}

        FirebaseConstants.trackMeDatabase.child(myUID).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let latitude = dictionary["latitude"] as? Double else {return}
                guard let longitude = dictionary["longitude"] as? Double else {return}
                let friendsLocation = CLLocationCoordinate2DMake(latitude, longitude)
                self.userImage = UIImage(named: "defaultUser")
                print(dictionary)
                DispatchQueue.main.async {
                    _ = self.markerCreater(location: friendsLocation, title: "Friend is here", image: "defaultUser")
                }
            }
        }
    }
}

extension LocationServicesViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            print("Hello!")
        }
//        else {}
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "searchLocationModal") as! SearchLocationModalViewController
        controller.passLocationCoordinatesBackDelegat = self
        //controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //self.navigationController?.present(controller, animated: true, completion: nil)
        self.present(controller, animated: true, completion: nil)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Now you're typing in me!")
    }
 
    
}

extension LocationServicesViewController: PassLocationCoordinatesBack {
    func didTapCell(coordinates: [CLLocationCoordinate2D]) {
        for locCoordinates in coordinates {
            _ = self.markerCreater(location: locCoordinates, title: "Here", image: "defaultUser")
        }
    }
    
    
}

