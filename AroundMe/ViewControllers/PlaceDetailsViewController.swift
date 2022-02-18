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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placeMapView: MKMapView!
    
    var tableViewRowData: Place = Place(title: "temp", distance: 320, image: UIImage(named: "warsaw")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = tableViewRowData.title
        titleLabel.text = tableViewRowData.title
        
        if let placeDistance = tableViewRowData.distance {
            distanceLabel.text = "\(placeDistance) km"
        } else {
            distanceLabel.text = "-"
        }
        
        descriptionLabel.text = tableViewRowData.description
        placeImage.image = tableViewRowData.image
        
        placeMapView.layer.cornerRadius = 20
        
        if let latitude = tableViewRowData.latitude, let longitude = tableViewRowData.longitude {
            let newPin = MKPointAnnotation()
            newPin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: newPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            placeMapView.addAnnotations([newPin])
            placeMapView.setRegion(region, animated: true)
        }
        
        placeMapView.showsUserLocation = true
    }

}
