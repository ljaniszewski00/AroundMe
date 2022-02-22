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
    private var favoritePlaces = [Place]()
    
    private init() {
        fetchFavoritePlaceObjects()
    }
    
    public func fetchFavoritePlaceObjects() {
        let favoritePlacesFromRealm = realm.objects(Place.self)
        for favoritePlaceFromRealm in favoritePlacesFromRealm {
            favoritePlaces.append(favoritePlaceFromRealm)
        }
    }
    
    public func getFavoritePlaces() -> [Place] {
        fetchFavoritePlaceObjects()
        return favoritePlaces
    }
    
    public func addPlaceObject(_ place: Place) {
        realm.beginWrite()
        realm.add(place)
        try! realm.commitWrite()
        fetchFavoritePlaceObjects()
        print("Successfully added new object to Realm!")
    }
    
    public func deletePlaceObject(_ place: Place) {
        if favoritePlaces.contains(place) {
            realm.beginWrite()
            realm.delete(place)
            try! realm.commitWrite()
            fetchFavoritePlaceObjects()
            print("Successfully deleted object!")
        } else {
            print("Could not delete because there is no such object in the Realm!")
        }
    }
    
    public func deleteAllPlaceObjects() {
        realm.beginWrite()
        realm.delete(realm.objects(Place.self))
        try! realm.commitWrite()
        fetchFavoritePlaceObjects()
        print("Successfully deleted all objects in Realm!")
    }
}
