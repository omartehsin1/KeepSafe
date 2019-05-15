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
        _ = markerCreater(location: currentLocation, title: "Current Location", image: userImage!)
        
        //getCrimeData()
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
    
    func markerCreater(location: CLLocationCoordinate2D, title: String, image: UIImage) -> GMSMarker {
        let marker = GMSMarker(position: location)
        marker.title = title
        marker.icon = resizeImage(image: image, newWidth: 50)
        marker.map = mapView
        return marker
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func getCrimeData() {
        
        guard let url = URL(string: "https://services.arcgis.com/S9th0jAJ7bqgIRjw/arcgis/rest/services/MCI_2014_to_2018/FeatureServer/0/query?where=reportedyear%20%3E%3D%202017%20AND%20reportedyear%20%3C%3D%202019&outFields=premisetype,offence,reportedyear,reportedmonth,reportedday,reporteddayofyear,reporteddayofweek,reportedhour,occurrenceyear,occurrencemonth,occurrenceday,occurrencedayofweek,occurrencehour,MCI,Neighbourhood,Lat,Long&outSR=4326&f=json") else { return }
        
        Alamofire.request(url, method: .get, parameters: ["features" : "attributes"], encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if let jsonValue = response.result.value {
                    let json = JSON(jsonValue)

                for(key, subJSON) in json["features"] {
                    if let lat = subJSON["attributes"]["Lat"].double, let long = subJSON["attributes"]["Long"].double {
                        let latAndLong = CLLocationCoordinate2DMake(lat, long)
                        self.crimeLocation.append(latAndLong)
                    }

                }

//                for crimeLocations in self.crimeLocation {
//                    _ = self.markerCreater(location: crimeLocations, title: "Crime Here", image: self.userImage!)
//                }
            }
        })
        
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
    func didTapSearch(coordinates: [CLLocationCoordinate2D]) {
        print(coordinates)
        for crimeCoordinates in coordinates {
            _ = self.markerCreater(location: crimeCoordinates, title: "Crime Here", image: self.userImage!)
            //print(crimeCoordinates)
        }
    }
    
    
}



