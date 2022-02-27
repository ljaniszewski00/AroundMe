//
//  PlaceDetailsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 25/02/2022.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class PlaceDetailsViewController: UIViewController {
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placeMapView: MKMapView!
    
    var tableViewRowData: DiscoveredPlace = DiscoveredPlace()
    var placeUIImage: UIImage = UIImage(systemName: "photo.on.rectangle.angled")!
//    var tableViewRowData: Place = Place(title: "temp", distance: 320, fullDescription: "", image: UIImage(systemName: "photo.on.rectangle.angled")!, latitude: 0, longitude: 0)
//    var usersLocation: CLLocation?
    
    private var toBeAddedToFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = tableViewRowData.title
        
        NotificationCenter.default.addObserver(self,
           selector: #selector(removeFavoriteMarker),
           name: NSNotification.Name(rawValue: "removeFavoriteMarker"),
           object: nil)
        
        NotificationCenter.default.addObserver(self,
           selector: #selector(addFavoriteMarker),
           name: NSNotification.Name(rawValue: "addFavoriteMarker"),
           object: nil)
        
        if tableViewRowData.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        favoriteButton.imageView?.contentMode = .scaleAspectFill
        favoriteButton.tintColor = .yellow
        
        titleLabel.text = tableViewRowData.title
        
        if tableViewRowData.distance != -1 {
            distanceLabel.text = "\(tableViewRowData.distance) km"
        } else {
            distanceLabel.text = "-"
        }
        
        descriptionLabel.text = tableViewRowData.fullDescription
        
        placeImage.image = placeUIImage
        if placeUIImage == UIImage(systemName: "photo.on.rectangle.angled") {
            placeImage.contentMode = .scaleAspectFit
        }
        
        placeMapView.layer.cornerRadius = 20
        
        if tableViewRowData.latitude != 0 && tableViewRowData.longitude != 0 {
            let newPin = MKPointAnnotation()
            newPin.coordinate = CLLocationCoordinate2D(latitude: tableViewRowData.latitude, longitude: tableViewRowData.longitude)
            
            let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            placeMapView.setRegion(region, animated: true)
            
            
            /*
             TRIED TO MAKE TWO POINTS (USER'S LOCATION AND SELECTED PLACE PIN) VISIBLE AT MAP AT IT'S LAUNCH
             
            if let usersLocation = usersLocation {
                let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: abs(usersLocation.coordinate.latitude - placeLatitude), longitudeDelta: abs(usersLocation.coordinate.longitude - placeLongitude)))
                placeMapView.setRegion(region, animated: true)
            } else {
                let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                placeMapView.setRegion(region, animated: true)
            }
             
             */
            
            placeMapView.addAnnotations([newPin])
        }
        
        placeMapView.showsUserLocation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if toBeAddedToFavorites {
            toBeAddedToFavorites = false
            RealmManager.shared.addPlaceCreatingNewObject(title: tableViewRowData.title, distance: tableViewRowData.distance, fullDescription: tableViewRowData.fullDescription, imageURLString: tableViewRowData.imageURLString, latitude: tableViewRowData.latitude, longitude: tableViewRowData.longitude, isFavorite: true)
        } else {
            toBeAddedToFavorites = true
        }
        
        for (index, discoveredPlace) in DiscoveredPlace.discoveredPlaces.enumerated() {
            if discoveredPlace.title == self.tableViewRowData.title {
                DiscoveredPlace.discoveredPlaces[index].isFavorite = !toBeAddedToFavorites
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if tableViewRowData.isFavorite {
            for (index, discoveredPlace) in DiscoveredPlace.discoveredPlaces.enumerated() {
                if discoveredPlace.title == tableViewRowData.title {
                    DiscoveredPlace.discoveredPlaces[index].isFavorite = false
                }
            }
            tableViewRowData.isFavorite = false
            sender.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
            toBeAddedToFavorites = false
        } else {
            for (index, discoveredPlace) in DiscoveredPlace.discoveredPlaces.enumerated() {
                if discoveredPlace.title == tableViewRowData.title {
                    DiscoveredPlace.discoveredPlaces[index].isFavorite = true
                }
            }
            tableViewRowData.isFavorite = true
            sender.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            toBeAddedToFavorites = true
        }
    }
    
    @objc func removeFavoriteMarker(_ notification: NSNotification) {
        tableViewRowData.isFavorite = false
        favoriteButton.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @objc func addFavoriteMarker(_ notification: NSNotification) {
        tableViewRowData.isFavorite = true
        favoriteButton.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
}
