//
//  TableViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit
import MapKit
import CoreLocation

class PlacesListViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PlacesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Place.testData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesListCell", for: indexPath) as? PlacesListCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
        let place = Place.testData[indexPath.row]
        cell.placeImage.layer.cornerRadius = 10
        cell.placeImage.image = place.image
        cell.titleLabel.text = place.title
        
        if let placeLatitude = Place.testData[indexPath.row].latitude, let placeLongitude = Place.testData[indexPath.row].longitude, let usersLocation = locationManager.location {
            let placeLocation = CLLocation(latitude: placeLatitude, longitude: placeLongitude)
            let distanceMeters = usersLocation.distance(from: placeLocation)
            let distanceKilometers = Int(distanceMeters / 1000)
            Place.testData[indexPath.row].distance = distanceKilometers
        }
        
        if let placeDistance = Place.testData[indexPath.row].distance {
            cell.distanceLabel.text = "\(placeDistance) km"
        } else {
            cell.distanceLabel.text = "-"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let tableViewRowData = Place.testData[indexPath.row]
            let placeDetailsViewController = segue.destination as! PlaceDetailsViewController
            placeDetailsViewController.tableViewRowData = tableViewRowData
        }
    }
}

