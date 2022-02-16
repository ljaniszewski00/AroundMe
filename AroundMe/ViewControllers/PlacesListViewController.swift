//
//  TableViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit

class PlacesListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Places"
    }
}

extension PlacesListViewController {
    static let placeListCellIdentifier = "PlacesListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Place.testData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.placeListCellIdentifier, for: indexPath) as? PlacesListCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
        let place = Place.testData[indexPath.row]
        cell.titleLabel.text = place.title
        cell.distanceLabel.text = String(place.distance) + " km"
        cell.placeImageButton.setBackgroundImage(place.image, for: .normal)
        cell.placeImageButton.layer.cornerRadius = 10
        cell.placeImageButton.clipsToBounds = true
        return cell
    }
}

