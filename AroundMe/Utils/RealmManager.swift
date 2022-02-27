//
//  RealmManager.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 22/02/2022.
//

import Foundation
import RealmSwift

final class RealmManager {
    static var shared: RealmManager = RealmManager()
    
    private let realm = try! Realm()
    var places: Results<Place>
    
    private init() {
        self.places = realm.objects(Place.self)
    }
    
    public func fetchPlaces() {
        self.places = realm.objects(Place.self)
    }
    
    public func addPlace(place: Place) -> Bool {
        if !self.places.contains(place) {
            try! realm.safeWrite {
                realm.add(place)
            }
            print("Successfully added new object to Realm!")
            fetchPlaces()
            return true
        } else {
            print("This object has already been added to Realm!")
            return false
        }
    }
    
    public func deletePlace(placeTitle: String) -> Bool {
        for place in places {
            if place.title == placeTitle {
                try! realm.safeWrite {
                    realm.delete(place)
                }
                print("Successfully deleted object from Realm!")
                fetchPlaces()
                return true
            }
        }
        
        print("Could not delete becuase there is no such object!")
        return false
    }
    
    public func addPlaceCreatingNewObject(title: String, distance: Int, fullDescription: String, imageURLString: String, latitude: Double, longitude: Double, isFavorite: Bool) -> Bool {
        var success = false
        try! realm.safeWrite {
            let place = Place(title: title, distance: distance, fullDescription: fullDescription, imageURLString: imageURLString, latitude: latitude, longitude: longitude, isFavorite: isFavorite)
            
            if !self.places.contains(place) {
                realm.add(place)
                success = true
            }
        }
        
        if success {
            print("Successfully added new object to Realm!")
            fetchPlaces()
            return true
        } else {
            print("This object has already been added to Realm!")
            return false
        }
    }
    
    public func deleteAllPlaceObjects() {
        try! realm.safeWrite {
            realm.delete(realm.objects(Place.self))
        }
        fetchPlaces()
        print("Successfully deleted all objects in Realm!")
    }

    public func deleteAllNonFavoritePlaceObjects() {
        for place in places {
            if !place.isFavorite {
                try! self.realm.safeWrite {
                    self.realm.delete(place)
                }
            }
        }
        fetchPlaces()
        print("Successfully deleted all non-favorite objects!")
    }
    
    public func updatePlaceDistance(place: Place, distance: Int) {
        try! self.realm.safeWrite {
            place.distance = distance
        }
        fetchPlaces()
    }

    public func markPlaceFavorite(place: Place) {
        try! self.realm.safeWrite {
            place.isFavorite = true
        }
        fetchPlaces()
    }
    
    public func unmarkPlaceFavorite(place: Place) {
        try! self.realm.safeWrite {
            place.isFavorite = false
        }
        
        fetchPlaces()
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
