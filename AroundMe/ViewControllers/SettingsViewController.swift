//
//  SettingsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 28/02/2022.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var localizationImage: UIImageView!
    @IBOutlet weak var localizationSwitch: UISwitch!
    @IBOutlet weak var deleteSavedPlacesButton: UIButton!
    @IBOutlet weak var placesPerPageSlider: UISlider!
    @IBOutlet weak var placesPerPageValue: UILabel!
    @IBOutlet weak var maxLocationRadius: UISlider!
    @IBOutlet weak var maxLocationRadiusValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizationSwitch.isOn = UserDefaults.standard.bool(forKey: "localizationSettingsSwitch")
        if localizationSwitch.isOn {
            localizationImage.image = UIImage(systemName: "location.fill")
        } else {
            localizationImage.image = UIImage(systemName: "location")
        }
        placesPerPageSlider.value = UserDefaults.standard.value(forKey: "placesPerPage") as! Float
        placesPerPageValue.text = String(Int(placesPerPageSlider.value))
        maxLocationRadius.value = UserDefaults.standard.value(forKey: "maxLocationRadius") as! Float
        maxLocationRadiusValue.text = String(Int(maxLocationRadius.value))
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func localizationSwitchPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "localizationSettingsSwitch")
        if sender.isOn {
            localizationImage.image = UIImage(systemName: "location.fill")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startMonitoringLocation"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startMonitoringFavoritePlacesLocation"), object: nil)
        } else {
            localizationImage.image = UIImage(systemName: "location")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMonitoringLocation"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopMonitoringFavoritePlacesLocation"), object: nil)
        }
    }
    
    @IBAction func deleteSavedPlacesButtonPressed(_ sender: UIButton) {
        RealmManager.shared.deleteAllPlaceObjects()
    }

    @IBAction func placesPerPageSliderValueChanged(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: "placesPerPage")
        placesPerPageValue.text = String(Int(sender.value))
    }
    
    @IBAction func maxLocationRadiusSliderValueChanged(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: "maxLocationRadius")
        maxLocationRadiusValue.text = String(Int(sender.value))
    }
    
}
