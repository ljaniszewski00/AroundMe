//
//  DiscoveredPlace.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 25/02/2022.
//

import Foundation

import UIKit
import Foundation
import RealmSwift

struct DiscoveredPlace {
    var title: String = ""
    var distance: Int = -1
    var fullDescription: String = ""
    var imageURLString: String = "photo.on.rectangle.angled"
    var latitude: Double = 0
    var longitude: Double = 0
    var isFavorite: Bool = false
    
    init() {}
    
    init(title: String, distance: Int, fullDescription: String, imageURLString: String, latitude: Double, longitude: Double, isFavorite: Bool) {
        self.title = title
        self.distance = distance
        self.fullDescription = fullDescription
        self.imageURLString = imageURLString
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
}

extension DiscoveredPlace {
    static var discoveredPlaces = [DiscoveredPlace]()
}
