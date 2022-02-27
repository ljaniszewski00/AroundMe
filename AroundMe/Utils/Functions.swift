//
//  Functions.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 21/02/2022.
//

import Foundation
import UIKit

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

func debugPrint(_ printText: String = "") {
    print()
    print("DEBUG PRINT")
    print()
    print(printText)
    print()
    print("DEBUG PRINT")
    print()
}

