//
//  Place.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit

struct Place {
    var title: String
    var distance: Int
    var image: UIImage
}

extension Place {
    static var testData = [
        Place(title: "Warsaw", distance: 150, image: UIImage(named: "warsaw")!),
        Place(title: "Lodz", distance: 0, image: UIImage(named: "lodz")!),
        Place(title: "Krakow", distance: 300, image: UIImage(named: "krakow")!)
    ]
}
