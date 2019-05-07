//
//  CrimeFilterViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-05-07.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class CrimeFilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var cityLabelView: UILabel!
    @IBOutlet weak var neighborhoodPickerView: UIPickerView!
    var pickerData : [String] = [String]()
    var selectedBorough : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.neighborhoodPickerView.delegate = self
        self.neighborhoodPickerView.dataSource = self
        
        pickerData = ["Old Toronto", "York", "East York", "Etobicoke", "North York", "Scarborough"]
        

        var eastYorkData = ["O'Connor-Parkview", "Thorncliffe Park", "Leaside-Bennington", "Broadview North", "Old East York", "Danforth Village - East York", "Woodbine-Lumsden", "Crescent Town"]
        var etobicokeData = ["West Humber-Clairville", "Mount Olive-Silverstone-Jamestown", "Thistletown-Beaumond Heights", "Rexdale-Kipling", "Elms-Old Rexdale", "Kingsview Village-The Westway", "Willowridge-Martingrove-Richview", "Humber Heights-Westmount", "Edenbridge-Humber Valley", "Princess-Rosethorn", "Eringate-Centennial-West Deane", "Markland Wood", "Etobicoke West Mall", "Islington-City Centre West", "Kingsway South", "Stonegate-Queensway", "Mimico", "New Toronto", "Long Branch", "Alderwood"]
        var northYorkData = ["Humber Summit", "Humbermede", "Pelmo Park-Humberlea", "Black Creek", "Glenfield-Jane Heights", "Downsview-Roding-CFB", "York University Heights", "Rustic", "Maple Leaf", "Brookhaven-Amesbury", "Yorkdale-Glen Park", "Englemount-Lawrence", "Clanton Park", "Bathurst Manor", "Westminster-Branson", "Newtonbrook West", "Willowdale West", "Lansing-Westgate", "Bedford Park-Nortown", "St.Andrew-Windfields", "Bridle Path-Sunnybrook-York Mills", "Banbury-Don Mills", "Victoria Village", "Flemingdon Park", "Parkwoods-Donalda", "Pleasant View", "Don Valley Village", "Hillcrest Village", "Bayview Woods-Steeles", "Newtonbrook East", "Willowdale East", "Bayview Village", "Henry Farm"]
        var oldTorontoData = ["East End-Danforth", "The Beaches", "Woodbine Corridor", "Greenwood-Coxwell", "Danforth", "Playter Estates-Danforth", "North Riverdale", "Blake-Jones", "South Riverdale", "Cabbagetown-South St.James Town", "Regent Park", "Moss Park", "North St.James Town", "Church-Yonge Corridor", "Bay Street Corridor", "Waterfront Communities-The Island", "Kensington-Chinatown", "University", "Palmerston-Little Italy", "Trinity-Bellwoods", "Niagara", "Dufferin Grove", "Little Portugal", "South Parkdale", "Roncesvalles", "High Park-Swansea", "High Park North", "Runnymede-Bloor West Village", "Junction Area", "Weston-Pellam Park", "Corso Italia-Davenport", "Dovercourt-Wallace Emerson-Junction", "Wychwood", "Annex", "Casa Loma", "Yonge-St.Clair", "Rosedale-Moore Park", "Mount Pleasant East", "Yonge-Eglinton", "Forest Hill South", "Forest Hill North", "Lawrence Park South", "Mount Pleasant West", "Lawrence Park North"]
        
        var scarboroughData = ["Steeles",
                               "L'Amoreaux", "Tam O'Shanter-Sullivan", "Wexford/Maryvale", "Clairlea-Birchmount", "Oakridge", "Birchcliffe-Cliffside", "Cliffcrest", "Kennedy Park", "Ionview", "Dorset Park", "Bendale", "Agincourt South-Malvern West", "Agincourt North", "Milliken", "Rouge", "Malvern", "Centennial Scarborough", "Highland Creek", "Morningside", "West Hill", "Woburn", "Eglinton East", "Scarborough Village", "Guildwood"]
        
        var yorkData = ["Humewood-Cedarvale", "Oakwood Village", "Briar Hill-Belgravia", "Caledonia-Fairbank", "Keelesdale-Eglinton West", "Rockcliffe-Smythe", "Beechborough-Greenbrook", "Weston", "Lambton Baby Point", "Mount Dennis"]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBorough = pickerData[row]
        cityLabelView.text = selectedBorough
    }


}

