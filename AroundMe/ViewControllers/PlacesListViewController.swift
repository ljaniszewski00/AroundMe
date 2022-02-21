//
//  TableViewController.swift
//  AroundMe
//
//  Created by Łukasz Janiszewski on 15/02/2022.
//

import UIKit
import MapKit
import CoreLocation
import WikipediaKit


class PlacesListViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var places: [Place] = [Place]()
    let wikipedia = Wikipedia()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        WikipediaNetworking.appAuthorEmailForAPI = "ljaniszewski00@gmail.com"
        
        self.makeAPICall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getCells() {
        
    }
}

extension PlacesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesListCell", for: indexPath) as? PlacesListCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
        let place = self.places[indexPath.row]
        cell.placeImage.layer.cornerRadius = 10
        cell.placeImage.image = place.image
        cell.titleLabel.text = place.title
        
        if let placeLatitude = self.places[indexPath.row].latitude, let placeLongitude = self.places[indexPath.row].longitude, let usersLocation = self.locationManager.location {
            let placeLocation = CLLocation(latitude: placeLatitude, longitude: placeLongitude)
            let distanceMeters = usersLocation.distance(from: placeLocation)
            let distanceKilometers = Int(distanceMeters / 1000)
            self.places[indexPath.row].distance = distanceKilometers
            
        }
        
        if let placeDistance = self.places[indexPath.row].distance {
            cell.distanceLabel.text = "\(placeDistance) km"
        } else {
            cell.distanceLabel.text = "-"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tableViewRowData = self.places[indexPath.row]
            let placeDetailsViewController = segue.destination as! PlaceDetailsViewController
            placeDetailsViewController.tableViewRowData = tableViewRowData
//            placeDetailsViewController.usersLocation = locationManager.location
        }
    }
    
    private func makeAPICall() {
        
        /*
         Using GeoDB Cities API from https://rapidapi.com/wirefreethought/api/geodb-cities/ to retrieve Cities Near Location results with GET method
         */
        
        if let usersLocation = self.locationManager.location {
            var locationID: String = ""
            
            if usersLocation.coordinate.latitude >= 0 {
                locationID = "+\(usersLocation.coordinate.latitude)"
            } else {
                locationID = "\(usersLocation.coordinate.latitude)"
            }
            
            if usersLocation.coordinate.longitude >= 0 {
                locationID = "\(locationID)+\(usersLocation.coordinate.longitude)"
            } else {
                locationID = "\(locationID)\(usersLocation.coordinate.longitude)"
            }
            
            let radius = 100
            let limit = 3
            
            /*
             
             URL request required parameters:
             1). locationid - Latitude/longitude in ISO-6709 format: ±DD.DDDD±DDD.DDDD
             2). radius - The location radius within which to find cities
             
             URL request optional parameters used:
             1). limit - The maximum number of results to retrieve
             Some more optional parameters can be found here https://rapidapi.com/wirefreethought/api/geodb-cities/
             
             */
            
            let url = URL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/locations/\(locationID)/nearbyCities?radius=\(radius)&limit=\(limit)")
            
            if let url = url {
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

                let header = [
                    "x-rapidapi-host": "wft-geo-db.p.rapidapi.com",
                    "x-rapidapi-key": "8d3c69b775mshcc24b34f5cf077dp1dea3bjsn71f7afa7ced8"
                ]

                request.allHTTPHeaderFields = header
                
                
                /*
                 
                 // Only applicable to POST request's method

                    let jsonObject: [String: Any] = [
                        "locationid": locationID,
                        "radius": radius,
                        "limit": limit
                    ]
    
                    do {
                        let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
    
                        request.httpBody = requestBody
                    } catch {
                        print("Error creating the data object from jsonObject")
                    }
                 
                 */

                request.httpMethod = "GET"

                let session = URLSession.shared

                let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
                    if error == nil && data != nil {
                        do {
                            // make dictionary type json object from downloaded data
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                            // select only values for "data" key in dictionary skipping other keys
                            if let jsonArrayForDataKey = jsonDictionary["data"] as? [Any] {
                                // for every entry in values from "data" key in dictionary
                                var apiPlaces = [APIPlace]()
                                for object in jsonArrayForDataKey {
                                    // make data object
                                    let apiPlaceData = try JSONSerialization.data(withJSONObject: object, options: [])
                                    // and decode it as APIPlace object
                                    let apiPlaceDecoded = try JSONDecoder().decode(APIPlace.self, from: apiPlaceData)
                                    apiPlaces.append(apiPlaceDecoded)
                                }
                                self?.getAllPlacesData(data: apiPlaces)
                            }
                        } catch {
                            print("Error making dictionary type json object from downloaded data")
                        }
                    }
                }

                dataTask.resume()
            } else {
                print("Error creating URL object")
            }
        }
    }
    
    private func getAllPlacesData(data: [APIPlace]) {
        let myGroup = DispatchGroup()
        
        for apiPlace in data {
            myGroup.enter()
            
            wikipedia.requestOptimizedSearchResults(language: WikipediaLanguage("en"), term: apiPlace.city) { (searchResult, error) in
                if let searchResult = searchResult {
                    let result = searchResult.items[0]
                    if let imageURL = result.imageURL {
                        downloadImage(from: imageURL) { image in
                            let newPlace = Place(title: apiPlace.city, distance: nil, description: result.displayText, image: image, latitude: apiPlace.latitude, longitude: apiPlace.longitude)
                            self.places.append(newPlace)
                            myGroup.leave()
                        }
                    } else {
                        let newPlace = Place(title: apiPlace.city, distance: nil, description: result.displayText, image: UIImage(systemName: "photo.on.rectangle.angled"), latitude: apiPlace.latitude, longitude: apiPlace.longitude)
                        self.places.append(newPlace)
                        myGroup.leave()
                    }
                }
            }
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.updateTableView()
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


