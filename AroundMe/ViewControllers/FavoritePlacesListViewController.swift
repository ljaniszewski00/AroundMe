//
//  FavoritePlacesListViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 25/02/2022.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class FavoritePlacesListCell: UITableViewCell {
    @IBOutlet var favoritePlaceImage: UIImageView!
    @IBOutlet var favoritetTitleLabel: UILabel!
    @IBOutlet var favoriteDistanceLabel: UILabel!
}

class FavoritePlacesListViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    @IBOutlet weak var refreshFavoritePlacesListButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
           selector: #selector(stopMonitoringFavoritePlacesLocation),
           name: NSNotification.Name(rawValue: "stopMonitoringFavoritePlacesLocation"),
           object: nil)
        
        NotificationCenter.default.addObserver(self,
           selector: #selector(startMonitoringFavoritePlacesLocation),
           name: NSNotification.Name(rawValue: "startMonitoringFavoritePlacesLocation"),
           object: nil)
        
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
    
    @IBAction func refreshFavoritePlacesListButtonPressed(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
}

extension FavoritePlacesListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(RealmManager.shared.places.count)
        return RealmManager.shared.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritePlacesListCell", for: indexPath) as? FavoritePlacesListCell else {
            fatalError("Unable to dequeue place cell")
        }
        
        if !RealmManager.shared.places.isEmpty {
            let place = RealmManager.shared.places[indexPath.row]
            
            cell.favoritePlaceImage.layer.cornerRadius = 10
            
            if cell.favoritePlaceImage == nil || cell.favoritePlaceImage.image != UIImage(systemName: place.imageURLString) {
                if place.imageURLString != "photo.on.rectangle.angled" && !place.imageURLString.isEmpty {
                    ImageDownloader.shared.downloadImage(with: place.imageURLString, completionHandler: { (image, cached) in
                        cell.favoritePlaceImage.image = image
                    }, placeholderImage: UIImage(systemName: place.imageURLString))
                } else {
                    cell.favoritePlaceImage.image = UIImage(systemName: place.imageURLString)
                }
            }
            
            cell.favoritetTitleLabel.text = place.title
            
            let placeLatitude = RealmManager.shared.places[indexPath.row].latitude
            let placeLongitude = RealmManager.shared.places[indexPath.row].longitude
            
            if let usersLocation = self.locationManager.location {
                if placeLatitude != 0 && placeLongitude != 0 {
                    let placeLocation = CLLocation(latitude: placeLatitude, longitude: placeLongitude)
                    let distanceMeters = usersLocation.distance(from: placeLocation)
                    let distanceKilometers = Int(distanceMeters / 1000)
                    RealmManager.shared.updatePlaceDistance(place: RealmManager.shared.places[indexPath.row], distance: distanceKilometers)
                }
                
            }
            
            let placeDistance = RealmManager.shared.places[indexPath.row].distance
            
            if placeDistance != -1 {
                cell.favoriteDistanceLabel.text = "\(placeDistance) km"
            } else {
                cell.favoriteDistanceLabel.text = "-"
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tableViewRowData = RealmManager.shared.places[indexPath.row]
            let favoritePlaceDetailsViewController = segue.destination as! FavoritePlaceDetailsViewController
            favoritePlaceDetailsViewController.tableViewRowData = tableViewRowData
            guard let cell = tableView.cellForRow(at: indexPath) as? FavoritePlacesListCell else {
                fatalError("Unable to get selected cell")
            }
            if let favoritePlaceImage = cell.favoritePlaceImage.image {
                favoritePlaceDetailsViewController.placeUIImage = favoritePlaceImage
            }
            
//            placeDetailsViewController.usersLocation = locationManager.location
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func stopMonitoringFavoritePlacesLocation(_ notification: NSNotification) {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    @objc func startMonitoringFavoritePlacesLocation(_ notification: NSNotification) {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
}
