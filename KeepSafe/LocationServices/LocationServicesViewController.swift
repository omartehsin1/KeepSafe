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
    var theLocations : CLLocation?
    var profileImageURL: String = "defaultUser"
    let myCircleTrackingView = UIView()
    let cellId = "cellId"
    var users = [Users]()
    
    let newCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collection.backgroundColor = UIColor.gray
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        
        return collection
    }()
    
    

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
        mapView.isMyLocationEnabled = true
        
        view = mapView

        locationManager.startUpdatingLocation()
        //myCircleTrackingView.isHidden = true
        
        //let crimeLocation = CLLocationCoordinate2DMake(latitude, longitude)
        
        //let marker = GMSMarker(position: currentLocation)
        //marker.title = "Current Location"
        
        //marker.icon = resizeImage(image: userImage!, newWidth: 50)
        //marker.map = mapView
        
//        let currentLocation = CLLocationCoordinate2DMake(43.6789923, -79.3120105)
//        userImage = UIImage(named: "defaultUser")
//        _ = markerCreater(location: currentLocation, title: "Current Location", image: "defaultUser")


        createButton()
        notificationCenter()
        
        newCollection.delegate = self
        newCollection.dataSource = self
        newCollection.register(CustomTrackingCell.self, forCellWithReuseIdentifier: cellId)
        
        //Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.startLiveLocation), userInfo: nil, repeats: true)
        
        


    }
    override func viewWillAppear(_ animated: Bool) {
        createFriendMarker()
        myCircleTrackingViewBar()
    }
    
    func myCircleTrackingViewBar() {
        
        guard let navY = navigationController?.navigationBar.frame.height else {return}
        
        myCircleTrackingView.frame = CGRect(x: 0, y: navY, width: UIScreen.main.bounds.width, height: 100)
        myCircleTrackingView.backgroundColor = UIColor.white
        myCircleTrackingView.alpha = 0.7
        
        myCircleTrackingView.addSubview(newCollection)
        view.addSubview(myCircleTrackingView)
        
        setUpCollection()
        fetchFollower()
    }
    
    func setUpCollection() {
        newCollection.centerXAnchor.constraint(equalTo: myCircleTrackingView.centerXAnchor).isActive = true
        newCollection.centerYAnchor.constraint(equalTo: myCircleTrackingView.centerYAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: myCircleTrackingView.frame.height).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: myCircleTrackingView.frame.width).isActive = true
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
    
    
    func createButton() {
        
        
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


        }

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
        self.mapView.animate(to: camera)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

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
        //NotificationCenter.default.addObserver(self, selector: #selector(showReportCrime), name: NSNotification.Name("ShowReportCrime"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(showPlaces), name: NSNotification.Name("ShowPlaces"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startLiveLocation), name: NSNotification.Name("StartLiveLocation"), object: nil)

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
    
    @objc func showTrackingView() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        //if selected database child key is myUID, show who's following me
        FirebaseConstants.selectedDatabase.child(myUID).observe(.value) { (snapshot) in
            if myUID == snapshot.key {
                self.myCircleTrackingView.isHidden = false
            }
        }
        
    }
    
    @objc func confirmTrackingAlert() {
        let alertController = UIAlertController(title: "Track Location ", message: "User wants to share their location", preferredStyle: UIAlertController.Style.alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            print("Cancel Pressed")
//        }
//        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in

            //Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.startLiveLocation), userInfo: nil, repeats: true)
            //NotificationCenter.default.addObserver(self, selector: #selector(self.startLiveLocation), name: NSNotification.Name("StartLiveLocation"), object: nil)


            
            
        }))
        

        self.present(alertController, animated: true, completion: nil)
    }
    

    @objc func startLiveLocation() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        guard let latitude = theLocations?.coordinate.latitude else {return}
        guard let longitude = theLocations?.coordinate.longitude else {return}
        var friendFollowUID : String!
        let timestamp = ServerValue.timestamp()
        
        let liveLocationDictionary :NSDictionary = ["latitude": latitude, "longitude": longitude, "timestamp": timestamp]
        
        FirebaseConstants.selectedDatabase.child(myUID).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let theFriendFollowUID = dictionary["friendUID"] as? String else {return}
                friendFollowUID = theFriendFollowUID
                let liveLocationDB = FirebaseConstants.trackingDatabase.child(friendFollowUID).child(myUID)
                liveLocationDB.setValue(liveLocationDictionary) { (error, ref) in
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
                guard let theFriendFollowUID = dictionary["friendUID"] as? String else {return}
                friendFollowUID = theFriendFollowUID
                let trackMeDB = FirebaseConstants.trackMeDatabase.child(myUID).child(friendFollowUID)
                trackMeDB.setValue(liveLocationDictionary) { (error, ref) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Location saved successfully")
                    }
                }
                
            }
        }
        
        
    }

    
    func createFriendMarker() {
        //FIND A WAY TO GET THAT SPEICIFC USERS IMAGE
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        var friendImageString: String!

        
        //let friendsImageView = UIImageView()
        //friendsImage.loadImageUsingCache(urlString: friendImageString!)
        //let friendsImage = friendsImageView.loadImageUsingCache(urlString: friendImageString)
        
        FirebaseConstants.trackingDatabase.child(myUID).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let latitude = dictionary["latitude"] as? Double else {return}
                guard let longitude = dictionary["longitude"] as? Double else {return}
                let friendsLocation = CLLocationCoordinate2DMake(latitude, longitude)
                self.userImage = UIImage(named: "defaultUser")
                _ = self.markerCreater(location: friendsLocation, title: "Friend is here", image: "defaultUser")
            }
        }
    }
    
    func fetchFollower() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        
        FirebaseConstants.trackMeDatabase.child(myUID).observe(.childAdded) { (snapshot) in
            let theUID = snapshot.key
            self.searchByUID(uid: theUID)
        }
    }
    
    func searchByUID(uid: String) {
        FirebaseConstants.userDatabase.child(uid).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                print(dictionary)
                let user = Users()
                user.nameOfUser = dictionary["nameOfUser"] as? String ?? ""
                user.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                print(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.newCollection.reloadData()
                }
            }
        }
    }
    
    


}

extension LocationServicesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newCollection.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomTrackingCell
        let user = users[indexPath.row]
        cell.textLabel.text = user.nameOfUser
        if let profileImageURL = user.profileImageURL {
            cell.imageView.loadImageUsingCache(urlString: profileImageURL)
        }
        //cell.backgroundColor = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    
}


class CustomTrackingCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    let imageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.backgroundColor = UIColor.gray
        return image
        
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = "New Person"

        return label
        
    }()
    func setUpView() {
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 7).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
