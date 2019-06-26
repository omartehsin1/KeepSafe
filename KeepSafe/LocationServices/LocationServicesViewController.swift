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
        let button = UIButton(frame: CGRect(x: 313, y: 584, width: 100, height: 50))
        button.backgroundColor = .blue
        button.setTitle("Query Data", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    @objc func buttonAction() {
//        performSegue(withIdentifier: "showCrimeFilter", sender: self)
        let crimeVC = storyboard?.instantiateViewController(withIdentifier: "CrimeFilter") as! CrimeFilterViewController
        crimeVC.passCoordinateBackDelegate = self
        present(crimeVC, animated: true, completion: nil)
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



