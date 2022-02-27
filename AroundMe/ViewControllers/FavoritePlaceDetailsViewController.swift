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

class FavoritePlaceDetailsViewController: UIViewController {
    @IBOutlet weak var favoritePlaceImage: UIImageView!
    @IBOutlet weak var favoriteTitleLabel: UILabel!
    @IBOutlet weak var favoriteButtonChanger: UIButton!
    @IBOutlet weak var favoriteDistanceLabel: UILabel!
    @IBOutlet weak var favoriteDescriptionLabel: UILabel!
    @IBOutlet weak var favoritePlaceMapView: MKMapView!
    
    var tableViewRowData: Place = Place()
    var placeUIImage: UIImage = UIImage(systemName: "photo.on.rectangle.angled")!
//    var tableViewRowData: Place = Place(title: "temp", distance: 320, fullDescription: "", image: UIImage(systemName: "photo.on.rectangle.angled")!, latitude: 0, longitude: 0)
//    var usersLocation: CLLocation?
    
    private var toBeDeletedFromFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = tableViewRowData.title
        
        if tableViewRowData.isFavorite {
            favoriteButtonChanger.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            favoriteButtonChanger.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        favoriteButtonChanger.imageView?.contentMode = .scaleAspectFill
        favoriteButtonChanger.tintColor = .yellow
        
        favoriteTitleLabel.text = tableViewRowData.title
        
        if tableViewRowData.distance != -1 {
            favoriteDistanceLabel.text = "\(tableViewRowData.distance) km"
        } else {
            favoriteDistanceLabel.text = "-"
        }
        
        favoriteDescriptionLabel.text = tableViewRowData.fullDescription
        
        favoritePlaceImage.image = placeUIImage
        if placeUIImage == UIImage(systemName: "photo.on.rectangle.angled") {
            favoritePlaceImage.contentMode = .scaleAspectFit
        }
        
        favoritePlaceMapView.layer.cornerRadius = 20
        
        if tableViewRowData.latitude == 0 && tableViewRowData.longitude == 0 {
            let newPin = MKPointAnnotation()
            newPin.coordinate = CLLocationCoordinate2D(latitude: tableViewRowData.latitude, longitude: tableViewRowData.longitude)
            
            let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            favoritePlaceMapView.setRegion(region, animated: true)
            
            
            /*
             TRIED TO MAKE TWO POINTS (USER'S LOCATION AND SELECTED PLACE PIN) VISIBLE AT MAP AT IT'S LAUNCH
             
            if let usersLocation = usersLocation {
                let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: abs(usersLocation.coordinate.latitude - placeLatitude), longitudeDelta: abs(usersLocation.coordinate.longitude - placeLongitude)))
                favoritePlaceMapView.setRegion(region, animated: true)
            } else {
                let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                favoritePlaceMapView.setRegion(region, animated: true)
            }
             
             */
            
            favoritePlaceMapView.addAnnotations([newPin])
        }
        
        favoritePlaceMapView.showsUserLocation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if toBeDeletedFromFavorites {
            toBeDeletedFromFavorites = false
            let tableViewRowDataTempTitle = tableViewRowData.title
            tableViewRowData = Place()
            RealmManager.shared.deletePlace(placeTitle: tableViewRowDataTempTitle)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeFavoriteMarker"), object: nil)
            for (index, discoveredPlace) in DiscoveredPlace.discoveredPlaces.enumerated() {
                if discoveredPlace.title == self.tableViewRowData.title {
                    DiscoveredPlace.discoveredPlaces[index].isFavorite = false
                }
            }
        } else {
            toBeDeletedFromFavorites = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addFavoriteMarker"), object: nil)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if tableViewRowData.isFavorite {
            RealmManager.shared.unmarkPlaceFavorite(place: tableViewRowData)
            sender.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
            print(RealmManager.shared.places)
            toBeDeletedFromFavorites = true
        } else {
            RealmManager.shared.markPlaceFavorite(place: tableViewRowData)
            sender.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            print(RealmManager.shared.places)
            toBeDeletedFromFavorites = false
        }
    }
    
}
