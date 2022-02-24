//
//  Place.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit
import Foundation
import RealmSwift

//struct Place: Equatable {
//    var title: String
//    var distance: Int?
//    var description: String?
//    var image: UIImage?
//    var latitude: Double?
//    var longitude: Double?
//}

class Place: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var distance: Int = -1
    @objc dynamic var fullDescription: String = ""
    @objc dynamic var image: UIImage = UIImage(systemName: "photo.on.rectangle.angled")!
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var isFavorite: Bool = false
    
    convenience init(title: String, distance: Int, fullDescription: String, image: UIImage, latitude: Double, longitude: Double, isFavorite: Bool) {
        self.init()
        self.title = title
        self.distance = distance
        self.fullDescription = fullDescription
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    static func ==(lhs: Place, rhs: Place) -> Bool {
        return lhs.title == rhs.title
        && lhs.fullDescription == rhs.fullDescription
    }
}

//public protocol Persistable {
//    associatedtype ManagedObject: RealmSwift.Object
//    init(managedObject: ManagedObject)
//    func managedObject() -> ManagedObject
//}


//extension Place: Persistable {
//    public init(managedObject: PlaceObject) {
//        title = managedObject.title
//        distance = managedObject.distance
//        description = managedObject.fullDescription
//        image = managedObject.image
//        latitude = managedObject.latitude
//        longitude = managedObject.longitude
//    }
//
//    public func managedObject() -> PlaceObject {
//        let place = PlaceObject()
//        place.title = title
//        place.distance = distance
//        place.fullDescription = description
//        place.image = image
//        place.latitude = latitude
//        place.longitude = longitude
//        return place
//    }
//}
