//
//  SettingsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 28/02/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var localizationSwitch: UISwitch!
    @IBOutlet weak var deleteSavedPlacesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizationSwitch.isOn = UserDefaults.standard.bool(forKey: "localizationSettingsSwitch")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func localizationSwitchPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "localizationSettingsSwitch")
        if sender.isOn {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startMonitoringLocation"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startMonitoringFavoritePlacesLocation"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMonitoringLocation"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMonitoringFavoritePlacesLocation"), object: nil)
        }
    }
    
    @IBAction func deleteSavedPlacesButtonPressed(_ sender: Any) {
        RealmManager.shared.deleteAllPlaceObjects()
    }

}
