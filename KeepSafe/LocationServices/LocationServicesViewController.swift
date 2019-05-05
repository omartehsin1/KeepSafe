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
        //let marker = GMSMarker(position: currentLocation)
        //marker.title = "Current Location"
        userImage = UIImage(named: "defaultUser")
        //marker.icon = resizeImage(image: userImage!, newWidth: 50)
        //marker.map = mapView
        let userMarker = markerCreater(location: currentLocation, title: "Current Location", image: userImage!)
        getCrimeData()

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
                    //print("JSON VALUE IS:  \(json)")
                    if let lat = json["features"][0]["attributes"]["Lat"].float, let long = json["features"][0]["attributes"]["Long"].float {
                        //latitude = lat
                        
                        print("Lat type is : \(lat) long is: \(long)" )
                    }
//                for(key, subJSON) in json["features"] {
//                    if let offence = subJSON["attributes"]["offence"].string {
//                        print("Offence type is : \(offence)" )
//                        }
//                    }
//                for(key, subJSON) in json["features"] {
//                    if let lat = subJSON["attributes"]["Lat"].float, let long = subJSON["attributes"]["Long"].float {
//                        print("Lat is : \(lat) Long is: \(long)")
//                        }
//                    }
                
                }
            })

        }

}

// https://services.arcgis.com/S9th0jAJ7bqgIRjw/arcgis/rest/services/MCI_2014_to_2018/FeatureServer/0/query?where=occurrenceyear%20%3E%3D%202017%20AND%20occurrenceyear%20%3C%3D%202019&outFields=premisetype,offence,reportedyear,reportedmonth,reportedday,reporteddayofweek,reportedhour,occurrenceyear,occurrencemonth,occurrencedayofyear,occurrencedayofweek,occurrencehour,MCI,Division,Neighbourhood,Lat,Long&outSR=4326&f=json


