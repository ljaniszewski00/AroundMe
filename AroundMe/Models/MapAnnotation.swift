//
//  MapAnnotation.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 18/02/2022.
//

import Foundation
import MapKit

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
