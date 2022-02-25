//
//  Place.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit
import Foundation
import RealmSwift

class Place: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var distance: Int = -1
    @objc dynamic var fullDescription: String = ""
    @objc dynamic var imageURLString: String = "photo.on.rectangle.angled"
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var isFavorite: Bool = false
    
    convenience init(title: String, distance: Int, fullDescription: String, imageURLString: String, latitude: Double, longitude: Double, isFavorite: Bool) {
        self.init()
        self.title = title
        self.distance = distance
        self.fullDescription = fullDescription
        self.imageURLString = imageURLString
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
    
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.title == rhs.title
        && lhs.fullDescription == rhs.fullDescription
    }
}
