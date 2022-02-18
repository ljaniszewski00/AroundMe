//
//  Place.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit

struct Place {
    var title: String
    var distance: Int?
    var description: String?
    var image: UIImage
    var latitude: Double?
    var longitude: Double?
}

extension Place {
    static var testData = [
        Place(title: "Warsaw",
              description: "Warsaw is the capital and largest city of Poland. The metropolis stands on the River Vistula in east-central Poland and its population is officially estimated at 1.8 million residents within a greater metropolitan area of 3.1 million residents, which makes Warsaw the 7th most-populous capital city in the European Union. The city area measures 517 km2 (200 sq mi) and comprises 18 boroughs, while the metropolitan area covers 6,100 km2 (2,355 sq mi).",
              image: UIImage(named: "warsaw")!,
              latitude: 52.237049,
              longitude: 21.017532),
        Place(title: "Lodz",
              description: "Łódź, also rendered in English as Lodz, is the third largest city in Poland and a former industrial centre. Located in the central part of the country, it has a population of 672,185 (2020). It is the capital of Łódź Voivodeship, and is located approximately 120 km (75 mi) south-west of Warsaw. The city's coat of arms is an example of canting, as it depicts a boat (łódź in Polish), which alludes to the city's name.",
              image: UIImage(named: "lodz")!,
              latitude: 51.759445,
              longitude: 19.457216),
        Place(title: "Krakow",
              description: "Krakow, also known in English as Cracow, is the second-largest and one of the oldest cities in Poland. Situated on the Vistula River in Lesser Poland Voivodeship, the city dates back to the seventh century. Kraków was the official capital of Poland until 1596 and has traditionally been one of the leading centres of Polish academic, economic, cultural and artistic life.",
              image: UIImage(named: "krakow")!,
              latitude: 50.049683,
              longitude: 19.944544)
    ]
}
