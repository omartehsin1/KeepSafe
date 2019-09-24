//
//  SearchLocationModalViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-09-23.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Firebase

protocol PassLocationCoordinatesBack {
    func didTapCell(coordinates: [CLLocationCoordinate2D])
}


class SearchLocationModalViewController: UIViewController {
    
    var saveButon = UIButton()
    
    @IBOutlet weak var theSearchBar: UISearchBar!
    //var resultsArray:[Dictionary<String, AnyObject>] = Array()
    var resultsArray: [LocationData] = [LocationData]()
    var passLocationCoordinatesBackDelegat: PassLocationCoordinatesBack!
    var savedLocation = [CLLocationCoordinate2D]()
    var searchedLocation = [CLLocationCoordinate2D]()
    var urlString : String?
    let savedLocationDB = FirebaseConstants.savedLocationsDatabase
    
    
    
    
    @IBOutlet weak var tableViewPlaces: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        theSearchBar.delegate = self
        tableViewPlaces.dataSource = self
        tableViewPlaces.delegate = self
        tableViewPlaces.estimatedRowHeight = 44.0
        retrieveSavedLocations()
  
    }    
    
    @IBAction func cancelBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let theUrlString = urlString  else {return}
        guard let theURL = URL(string: theUrlString) else {return}
        Alamofire.request(theURL, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                
                for (_, subJSON) in json["results"] {
                    guard let myUID = Auth.auth().currentUser?.uid else {return}
                    guard let theAddress = subJSON["formatted_address"].string else {return}
                    guard let lat = subJSON["geometry"]["location"]["lat"].double else {return}
                    guard let lng = subJSON["geometry"]["location"]["lng"].double else {return}
                    let reference = self.savedLocationDB.child(myUID).childByAutoId()
                    let theSavedLocation: NSDictionary = ["id" : reference.key!, "address": theAddress, "lat": lat, "lng": lng, "state": "saved"]
                    
                    self.savedLocationDB.child(myUID).childByAutoId().setValue(theSavedLocation)
                    
                }
            }
        }
    }
    func retrieveSavedLocations() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let ref = savedLocationDB.child(myUID)
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let locationData = LocationData()
                locationData.id = ref.key!
                locationData.address = dictionary["address"] as? String
                locationData.lat = dictionary["lat"] as? Double
                locationData.lng = dictionary["lng"] as? Double
                locationData.state = dictionary["state"] as? String
//                guard let theSaveButton = self.saveButon.viewWithTag(102) as? UIButton else {return}
//                if locationData.state == "saved" {
//                    theSaveButton.titleLabel?.text = "Unsave"
//                }
                
                self.resultsArray.append(locationData)
                
                DispatchQueue.main.async {
                    self.tableViewPlaces.reloadData()
                }
            }
        }
    }
    
}

extension SearchLocationModalViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else {return}
        searchPlaceFromGoogle(place: search)
        print(search)
        
    }
    func searchPlaceFromGoogle(place: String) {
        guard let formattedPlace = place.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(formattedPlace)&key=AIzaSyDqM1FD6oPJaSgZTmGKb8_vp44GTEz4ddU"
        urlString = strGoogleApi
        guard let url = URL(string: strGoogleApi) else {return}
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                for(_, subJSON) in json["results"] {
                    let locationData = LocationData()
                    locationData.address = subJSON["formatted_address"].string
                    locationData.lat = subJSON["geometry"]["location"]["lat"].double
                    locationData.lng = subJSON["geometry"]["location"]["lng"].double
                    self.resultsArray.append(locationData)
                    
                    
                }
                DispatchQueue.main.async {
                    self.tableViewPlaces.reloadData()
                }
            }
        }

    }
}

extension SearchLocationModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! UITableViewCell
        if let labelPlaceName = cell.contentView.viewWithTag(102) as? UILabel {
            if let place = self.resultsArray[indexPath.row].address {
                labelPlaceName.text = "\(place)"
            }
        }
//        if let button = cell.contentView.viewWithTag(101) as? UIButton {
//            saveButon = button
//
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lat = self.resultsArray[indexPath.row].lat else {return}
        guard let lng = self.resultsArray[indexPath.row].lng else {return}
        
        let latAndLng = CLLocationCoordinate2DMake(lat, lng)
        
        
        
        
        self.searchedLocation.append(latAndLng)
        
        self.passLocationCoordinatesBackDelegat.didTapCell(coordinates: self.searchedLocation)
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class LocationTableViewCell: UITableViewCell {
    
}
