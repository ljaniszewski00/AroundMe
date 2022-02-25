//
//  PlaceDetailsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 16/02/2022.
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
    
    var tableViewRowData: Place = Place()
    var placeUIImage: UIImage = UIImage(systemName: "photo.on.rectangle.angled")!
//    var tableViewRowData: Place = Place(title: "temp", distance: 320, fullDescription: "", image: UIImage(systemName: "photo.on.rectangle.angled")!, latitude: 0, longitude: 0)
//    var usersLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = tableViewRowData.title
        
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
        
        if tableViewRowData.latitude == 0 && tableViewRowData.longitude == 0 {
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
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if tableViewRowData.isFavorite {
            RealmManager.shared.unmarkPlaceUnfavorite(place: tableViewRowData)
            sender.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
            print(RealmManager.shared.getPlaces())
        } else {
            RealmManager.shared.markPlaceFavorite(place: tableViewRowData)
            sender.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            print(RealmManager.shared.getPlaces())
        }
    }
    
}
