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

protocol DidTapSOS {
    func didTapSOSButton(friendID: [String])
}

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
    var friendsUIDArray = [String]()
    var tappedSOSButtonDelegate : DidTapSOS!
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //api key: AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        

        //mapView.delegate = self

        GMSServices.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        GMSPlacesClient.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        
        let camera = GMSCameraPosition.camera(withLatitude: 43.6789923, longitude: -79.3120105, zoom: 17)

        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //self.locationManager.delegate = self
        view = mapView
 
        
        let currentLocation = CLLocationCoordinate2DMake(43.6789923, -79.3120105)
        //let crimeLocation = CLLocationCoordinate2DMake(latitude, longitude)
        
        //let marker = GMSMarker(position: currentLocation)
        //marker.title = "Current Location"
        userImage = UIImage(named: "defaultUser")
        //marker.icon = resizeImage(image: userImage!, newWidth: 50)
        //marker.map = mapView
        _ = markerCreater(location: currentLocation, title: "Current Location", image: "defaultUser")


        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(buttonAction))
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(buttonAction))
        createButton()
        


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
        
        
        let SOSButton = UIButton(frame: CGRect(x: 200, y: 546, width: 107, height: 100))
        //let SOSButton = UIButton()

        SOSButton.layer.cornerRadius = 50
        SOSButton.layer.masksToBounds = true
        
        SOSButton.backgroundColor = .orange
        SOSButton.setTitle("SOS", for: .normal)
        SOSButton.addTarget(self, action: #selector(sosPressed), for: .touchUpInside)
//        SOSButton.translatesAutoresizingMaskIntoConstraints = false
//
//
//        [SOSButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
//         SOSButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
//         SOSButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100),
//        SOSButton.heightAnchor.constraint(equalToConstant: 40),
//        SOSButton.widthAnchor.constraint(equalToConstant: 100)
//
//            ].forEach{$0.isActive = true}
        
        
        //view.bringSubviewToFront(SOSButton)
        //mapView.bringSubviewToFront(SOSButton)
        

//
        self.view.addSubview(SOSButton)
    }
    @objc func sosPressed() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        friendDataBase.child(myUID).observe(.value) { (snapshot) in
            for friendsUID in snapshot.children.allObjects as! [DataSnapshot] {
                if let dictionary = friendsUID.value as? [String: AnyObject] {
                    
                    let uid = dictionary["UID"] as? String ?? ""
                    self.friendsUIDArray.append(uid)
                    
                    //self.tappedSOSButtonDelegate.didTapSOSButton(friendID: self.friendsUIDArray)
                    
                }
                
            }
            
            let messageCollectionVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendChatViewController") as! FriendsChatViewController
            
            messageCollectionVC.friendsUID = self.friendsUIDArray
            self.navigationController?.pushViewController(messageCollectionVC, animated: true)

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



