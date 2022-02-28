//
//  SettingsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 28/02/2022.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var localizationSwitch: UISwitch!
    @IBOutlet weak var deleteSavedPlacesButton: UIButton!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    @IBAction func localizationSwitchPressed(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func deleteSavedPlacesButtonPressed(_ sender: Any) {
        RealmManager.shared.deleteAllPlaceObjects()
    }

}
