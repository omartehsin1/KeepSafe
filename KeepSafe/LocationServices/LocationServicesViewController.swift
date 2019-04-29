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


class LocationServicesViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var userCurrentLocation : GMSMarker?
    var userImage: UIImage?
    


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
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Home"
        
        userImage = UIImage(named: "defaultUser")
        
        
        marker.icon = resizeImage(image: userImage!, newWidth: 50)
        marker.map = mapView

 
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
    


}

//extension LocationServicesViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last
//        camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
//        self.mapView.animate(to: camera)
//        self.locationManager.stopUpdatingLocation()
//
//
//    }
//}
