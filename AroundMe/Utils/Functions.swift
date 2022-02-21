//
//  Functions.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 21/02/2022.
//

import Foundation
import UIKit

private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

func downloadImage(from url: URL, completion: @escaping ((UIImage) -> Void)) {
    print("Download Started")
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        completion(UIImage(data: data)!)
    }
}
