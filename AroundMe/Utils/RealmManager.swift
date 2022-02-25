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
    private var places: Results<Place>
    
    private init() {
        self.places = realm.objects(Place.self)
    }
    
    public func fetchPlaces() {
        self.places = realm.objects(Place.self)
    }
    
    public func getPlaces() -> Results<Place> {
        return self.places
    }
    
    public func addPlace(place: Place) -> Bool {
        if !self.places.contains(place) {
            try! realm.write {
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
    
    public func addPlaceCreatingNewObject(title: String, distance: Int, fullDescription: String, imageURLString: String, latitude: Double, longitude: Double, isFavorite: Bool) -> Bool {
        var success = false
        try! realm.write {
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
        try! realm.write {
            realm.delete(realm.objects(Place.self))
        }
        fetchPlaces()
        print("Successfully deleted all objects in Realm!")
    }

    public func deleteAllNonFavoritePlaceObjects() {
        for place in places {
            if !place.isFavorite {
                try! self.realm.write {
                    self.realm.delete(place)
                }
            }
        }
        fetchPlaces()
        print("Successfully deleted all non-favorite objects!")
    }
    
    public func updatePlaceDistance(place: Place, distance: Int) {
        try! self.realm.write {
            place.distance = distance
        }
        fetchPlaces()
    }

    public func markPlaceFavorite(place: Place) {
        try! self.realm.write {
            place.isFavorite = true
        }
        fetchPlaces()
    }
    
    public func unmarkPlaceUnfavorite(place: Place) {
        try! self.realm.write {
            place.isFavorite = false
        }
        fetchPlaces()
    }
}
