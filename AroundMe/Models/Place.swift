//
//  Place.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit

struct Place: Equatable {
    var title: String
    var distance: Int?
    var description: String?
    var image: UIImage?
    var latitude: Double?
    var longitude: Double?
}

extension Place {
    static var favorites = [Place]()
}

