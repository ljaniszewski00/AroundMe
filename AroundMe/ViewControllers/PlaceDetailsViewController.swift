//
//  PlaceDetailsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 16/02/2022.
//

import UIKit
import MapKit
import CoreLocation

class PlaceDetailsViewController: UIViewController {
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placeMapView: MKMapView!
    
    var tableViewRowData: Place = Place(title: "temp", distance: 320, image: UIImage(systemName: "photo.on.rectangle.angled")!)
//    var usersLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = tableViewRowData.title
        favoriteButton.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.imageView?.contentMode = .scaleAspectFill
        favoriteButton.tintColor = .yellow
        titleLabel.text = tableViewRowData.title
        
        if let placeDistance = tableViewRowData.distance {
            distanceLabel.text = "\(placeDistance) km"
        } else {
            distanceLabel.text = "-"
        }
        
        descriptionLabel.text = tableViewRowData.description
        placeImage.image = tableViewRowData.image
        
        placeMapView.layer.cornerRadius = 20
        
        if let placeLatitude = tableViewRowData.latitude, let placeLongitude = tableViewRowData.longitude {
            let newPin = MKPointAnnotation()
            newPin.coordinate = CLLocationCoordinate2D(latitude: placeLatitude, longitude: placeLongitude)
            
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
        if Place.favorites.contains(tableViewRowData) {
            for (index, place) in Place.favorites.enumerated() {
                if place == tableViewRowData {
                    Place.favorites.remove(at: index)
                    break
                }
            }
            sender.setImage(UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            Place.favorites.append(tableViewRowData)
            sender.setImage(UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
}
