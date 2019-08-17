//
//  GuardianView.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-09.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleMaps
import GooglePlaces

class GuardianView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var turnOffButton: UIButton!
    var users = [Users]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        GMSServices.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        GMSPlacesClient.provideAPIKey("AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM")
        fetchWolf()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func offBTNPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConfirmStopTracking"), object: nil)
//        guard let myUID = Auth.auth().currentUser?.uid else {return}
//        let alertController = UIAlertController(title: "Stop Following?", message: "Are you sure you want to stop following this user?", preferredStyle: UIAlertController.Style.alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
//            FirebaseConstants.trackMeDatabase.child(myUID).removeValue()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            print("Cancel")
//        }
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GuardianView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    func fetchWolf() {
        guard let myUID = Auth.auth().currentUser?.uid else {return}
        let geocoder = GMSGeocoder()
        FirebaseConstants.trackMeDatabase.child(myUID).observe(.childAdded) { (snapshot) in
            
            FirebaseConstants.userDatabase.child(snapshot.key).observe(.value, with: { (snap) in
                if let dictionary = snap.value as? [String: AnyObject] {
                    guard let wolfName = dictionary["nameOfUser"] as? String else {return}
                    guard let wolfImage = dictionary["profileImageURL"] as? String else {return}

                    self.nameLabel.text = wolfName
                    self.userImageView.loadImageUsingCache(urlString: wolfImage)

                }
            })
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let latitude = dictionary["latitude"] as? Double else {return}
                guard let longitude = dictionary["longitude"] as? Double else {return}
                let friendsLocation = CLLocationCoordinate2DMake(latitude, longitude)
                
                geocoder.reverseGeocodeCoordinate(friendsLocation, completionHandler: { (response, error) in
                    if let address = response?.firstResult() {
                        guard let lines = address.lines else {return}
                        let completeAdress = lines.joined(separator: " ")
                        self.locationLabel.text = completeAdress
                    }
                })
            }
        }
    }
    

}
