//
//  CrimeFilterViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-05-07.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces

protocol PassCoordinatesBack {
    func didTapSearch(coordinates: [CLLocationCoordinate2D])
}

class CrimeFilterViewController: UIViewController {

    @IBOutlet weak var boroughTextField: UITextField!
    @IBOutlet weak var neighborhoodTextField: UITextField!
    @IBOutlet weak var boroughPickerView: UIPickerView!
    
    @IBOutlet weak var crimeTypeTextField: UITextField!
    
    @IBOutlet weak var crimePickerView: UIPickerView!
    
    var pickerData : [String] = [String]()
    var oldTorontoData : [String] = [String]()
    var eastYorkData : [String] = [String]()
    var etobicokeData : [String] = [String]()
    var northYorkData : [String] = [String]()
    var scarboroughData : [String] = [String]()
    var yorkData : [String] = [String]()
    var crimeData : [String] = [String]()
    var selectedBorough : String!
    var selectedNeighborHood : String!
    var crimeType : String!
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    var crimeLocation = [CLLocationCoordinate2D]()
    var passCoordinateBackDelegate: PassCoordinatesBack!

    override func viewDidLoad() {
        super.viewDidLoad()
        //createBoroughPicker()
        //createCrimeTypePicker()
        createToolbar()
        createNeighborhoodpicker()
        pickerData = ["Old Toronto", "York", "East York", "Etobicoke", "North York", "Scarborough"]
        boroughPickerView.delegate = self
        boroughPickerView.dataSource = self
        crimePickerView.delegate = self
        crimePickerView.dataSource = self
        crimeTypeTextField.delegate = self
        
        
        eastYorkData = ["O'Connor-Parkview", "Thorncliffe Park", "Leaside-Bennington", "Broadview North", "Old East York", "Danforth Village - East York", "Woodbine-Lumsden", "Crescent Town"]
        etobicokeData = ["West Humber-Clairville", "Mount Olive-Silverstone-Jamestown", "Thistletown-Beaumond Heights", "Rexdale-Kipling", "Elms-Old Rexdale", "Kingsview Village-The Westway", "Willowridge-Martingrove-Richview", "Humber Heights-Westmount", "Edenbridge-Humber Valley", "Princess-Rosethorn", "Eringate-Centennial-West Deane", "Markland Wood", "Etobicoke West Mall", "Islington-City Centre West", "Kingsway South", "Stonegate-Queensway", "Mimico", "New Toronto", "Long Branch", "Alderwood"]
        northYorkData = ["Humber Summit", "Humbermede", "Pelmo Park-Humberlea", "Black Creek", "Glenfield-Jane Heights", "Downsview-Roding-CFB", "York University Heights", "Rustic", "Maple Leaf", "Brookhaven-Amesbury", "Yorkdale-Glen Park", "Englemount-Lawrence", "Clanton Park", "Bathurst Manor", "Westminster-Branson", "Newtonbrook West", "Willowdale West", "Lansing-Westgate", "Bedford Park-Nortown", "St.Andrew-Windfields", "Bridle Path-Sunnybrook-York Mills", "Banbury-Don Mills", "Victoria Village", "Flemingdon Park", "Parkwoods-Donalda", "Pleasant View", "Don Valley Village", "Hillcrest Village", "Bayview Woods-Steeles", "Newtonbrook East", "Willowdale East", "Bayview Village", "Henry Farm"]
        oldTorontoData = ["East End-Danforth", "The Beaches", "Woodbine Corridor", "Greenwood-Coxwell", "Danforth", "Playter Estates-Danforth", "North Riverdale", "Blake-Jones", "South Riverdale", "Cabbagetown-South St.James Town", "Regent Park", "Moss Park", "North St.James Town", "Church-Yonge Corridor", "Bay Street Corridor", "Waterfront Communities-The Island", "Kensington-Chinatown", "University", "Palmerston-Little Italy", "Trinity-Bellwoods", "Niagara", "Dufferin Grove", "Little Portugal", "South Parkdale", "Roncesvalles", "High Park-Swansea", "High Park North", "Runnymede-Bloor West Village", "Junction Area", "Weston-Pellam Park", "Corso Italia-Davenport", "Dovercourt-Wallace Emerson-Junction", "Wychwood", "Annex", "Casa Loma", "Yonge-St.Clair", "Rosedale-Moore Park", "Mount Pleasant East", "Yonge-Eglinton", "Forest Hill South", "Forest Hill North", "Lawrence Park South", "Mount Pleasant West", "Lawrence Park North"]
        
        scarboroughData = ["Steeles",
                           "L'Amoreaux", "Tam O'Shanter-Sullivan", "Wexford/Maryvale", "Clairlea-Birchmount", "Oakridge", "Birchcliffe-Cliffside", "Cliffcrest", "Kennedy Park", "Ionview", "Dorset Park", "Bendale", "Agincourt South-Malvern West", "Agincourt North", "Milliken", "Rouge", "Malvern", "Centennial Scarborough", "Highland Creek", "Morningside", "West Hill", "Woburn", "Eglinton East", "Scarborough Village", "Guildwood"]
        
        yorkData = ["Humewood-Cedarvale", "Oakwood Village", "Briar Hill-Belgravia", "Caledonia-Fairbank", "Keelesdale-Eglinton West", "Rockcliffe-Smythe", "Beechborough-Greenbrook", "Weston", "Lambton Baby Point", "Mount Dennis"]
        crimeData = ["Assault", "Robbery", "Break and Enter", "Theft"]
        
        crimePickerView.isHidden = true
        
    }
    
    func createBoroughPicker() {
        let boroughPicker = UIPickerView()
        boroughPicker.delegate = self
        
        boroughTextField.inputView = boroughPicker
    }
    
    func createNeighborhoodpicker() {
        let neighborhoodPicker = UIPickerView()
        neighborhoodPicker.delegate = self
        neighborhoodTextField.inputView = neighborhoodPicker
    }
    func createCrimeTypePicker() {
        var crimeTypePicker = UIPickerView()
        crimeTypePicker.delegate = self
        crimeTypeTextField.inputView = crimeTypePicker
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dimissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        boroughTextField.inputAccessoryView = toolBar
        
        neighborhoodTextField.inputAccessoryView = toolBar
        
        crimeTypeTextField.inputAccessoryView = toolBar
    }
    
    @objc func dimissKeyboard() {
        view.endEditing(true)
    }
    
    func crimeDataSearch(neighborhood: String, theCrimeType: String) {
        let formattedNeighborood = neighborhood.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let crimeType = theCrimeType

        let url = URL(string: "https://services.arcgis.com/S9th0jAJ7bqgIRjw/arcgis/rest/services/MCI_2014_to_2018/FeatureServer/0/query?where=reportedyear%20%3E%3D%202017%20AND%20reportedyear%20%3C%3D%202018%20AND%20UPPER(Neighbourhood)%20like%20%27%25\(formattedNeighborood)%25%27%20AND%20MCI%20%3D%20%27\(crimeType)%27&outFields=*&outSR=4326&f=json")!
        print("URL IS: \(url)")
        
        Alamofire.request(url, method: .get, parameters: ["features" : "attributes"], encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if let jsonValue = response.result.value {
                let json = JSON(jsonValue)
                
                for(_, subJSON) in json["features"] {
                    if let lat = subJSON["attributes"]["Lat"].double, let long = subJSON["attributes"]["Long"].double {
                        let latAndLong = CLLocationCoordinate2DMake(lat, long)
                        self.crimeLocation.append(latAndLong)
                        //print(self.crimeLocation)
                    }
                }
                
//                for crimeLocations in self.crimeLocation {
//                    _ = self.markerCreater(location: crimeLocations, title: "Crime Here", image: self.userImage!)
//                }
            }
            
        })
    }

    
    @IBAction func searchButtonPressed(_ sender: Any) {
        crimeDataSearch(neighborhood: selectedNeighborHood, theCrimeType: crimeType)
        passCoordinateBackDelegate.didTapSearch(coordinates: crimeLocation)
        dismiss(animated: true, completion: nil)

        
    }
    
    
}

extension CrimeFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == boroughPickerView {
            return pickerData.count
        }
        
        if pickerView == crimePickerView {
            return crimeData.count
        }
        if selectedBorough == "Old Toronto" {
            return oldTorontoData.count
        } else if selectedBorough == "York" {
            return yorkData.count
        } else if selectedBorough == "East York" {
            return eastYorkData.count
        } else if selectedBorough == "Etobicoke" {
            return etobicokeData.count
        } else if selectedBorough == "North York" {
            return northYorkData.count
        } else if selectedBorough == "Scarborough" {
            return scarboroughData.count
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == boroughPickerView {
            
            return pickerData[row]
        }
        if pickerView == crimePickerView {
            return crimeData[row]
        }
        
        if selectedBorough == "Old Toronto" {
            return oldTorontoData[row]
        } else if selectedBorough == "York" {
            return yorkData[row]
        } else if selectedBorough == "East York" {
            return eastYorkData[row]
        } else if selectedBorough == "Etobicoke" {
            return etobicokeData[row]
        } else if selectedBorough == "North York" {
            return northYorkData[row]
        } else if selectedBorough == "Scarborough" {
            return scarboroughData[row]
        }
        
        return ""
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == boroughPickerView {
            selectedBorough = pickerData[row]
            boroughTextField.text = selectedBorough
            print("the selected neighborhood is: \(selectedBorough ?? "")")
        }
        
        if pickerView == crimePickerView {
            crimeType = crimeData[row]
            crimePickerView.isHidden = true
            crimeTypeTextField.text = crimeType
        }
        
        if selectedBorough == "Old Toronto" {
            selectedNeighborHood = oldTorontoData[row]
            neighborhoodTextField.text = selectedNeighborHood
//            print("the selected neighborhood is: \(selectedNeighborHood ?? "")")
//            crimeDataSearch(neighborhood: selectedNeighborHood)
        } else if selectedBorough == "York" {
            selectedNeighborHood = yorkData[row]
            neighborhoodTextField.text = selectedNeighborHood
        } else if selectedBorough == "East York" {
            selectedNeighborHood = eastYorkData[row]
            neighborhoodTextField.text = selectedNeighborHood
        } else if selectedBorough == "Etobicoke" {
            selectedNeighborHood = etobicokeData[row]
            neighborhoodTextField.text = selectedNeighborHood
        } else if selectedBorough == "North York" {
            selectedNeighborHood = northYorkData[row]
            neighborhoodTextField.text = selectedNeighborHood
        } else if selectedBorough == "Scarborough" {
            selectedNeighborHood = scarboroughData[row]
            neighborhoodTextField.text = selectedNeighborHood
        }
        
    }
    
    
}

extension CrimeFilterViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        crimePickerView.isHidden = false
        return false
    }

}
