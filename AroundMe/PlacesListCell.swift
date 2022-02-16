//
//  PlacesListCell.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit


class PlacesListCell: UITableViewCell {
    @IBOutlet var placeImageButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    @IBAction func placeImageButtonTapped(_ sender: Any) {
        print("Image was tapped")
    }
}
