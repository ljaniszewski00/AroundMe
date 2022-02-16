//
//  PlaceDetailsViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 16/02/2022.
//

import UIKit
import MapKit

class PlaceDetailsViewController: UIViewController {
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placeMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeMapView.showsUserLocation = true
        placeMapView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
}
