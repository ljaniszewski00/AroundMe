//
//  APIPlace.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 20/02/2022.
//

import Foundation

struct APIPlace {
    var city: String
    var country: String
    var countryCode: String
    var distance: Double
    var id: Int
    var latitude: Double
    var longitude: Double
    var name: String
    var population: Int
    var region: String
    var regionCode: String
    var type: String
    var wikiDataId: String
}

extension APIPlace: Decodable {
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case country = "country"
        case countryCode = "countryCode"
        case distance = "distance"
        case id = "id"
        case latitude = "latitude"
        case longitude = "longitude"
        case name = "name"
        case population = "population"
        case region = "region"
        case regionCode = "regionCode"
        case type = "type"
        case wikiDataId = "wikiDataId"
    }
}
