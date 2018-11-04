//
//  LocsController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Modified by Yifan Li on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

// Struct for saving restaurant info
struct restaurantInfo {
    var name: String
    var address: String
    var rating: Float
    var priceLevel: Int
}

class LocsController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var tableView: UIView!
    
    var locationType: String = ""
    
    // Constants
    let googlePlaceSearchURL = "https://maps.googleapis.com/maps/api/place/textsearch/json"
    let API_KEY = "AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4"
    let locationManager  = CLLocationManager()
    var restaurantList = [restaurantInfo]()
    
    var locs = [
        Location(name: "Teer"),
        Location(name: "Hudson Hall"),
        Location(name: "Bryan Center")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location manager setup
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("Loading LocsView")
        let tableViewController = TableViewController()
        tableView.addSubview(tableViewController.view)
        tableViewController.view.fillSuperView()
        addChild(tableViewController)
        
        tableViewController.locs = locs
        
        // Used for testing GET request (passed)
        //        getPlaceData(url: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurant&location=42.3675294,-71.186966&radius=10000&key=AIzaSyDzi0HPWH371bh1Y96mRNQQhIgroKkQqk4", parameters: [:])
    }
    
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // the last value in locations is the most accurate (most recent)
        let location  = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String: String] = ["query": locationType, "location": "\(latitude),\(longitude)", "radius": "250", "key": API_KEY]
            //            let params : [String: String] = ["query": "restaurant", "location": "\(42.3675294),\(-71.186966)", "radius": "10000", "key": API_KEY]
            
            
            getPlaceData(url: googlePlaceSearchURL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        // TODO: - Display "Location Unavailable" somewhere
        print("Location Unavailable")
    }
    
    
    // MARK: - Networking
    func getPlaceData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the nearby place data")
                let nearbyPlacesJSON: JSON = JSON(response.result.value!) //comes from swiftyJSON
                self.parseJSON(json: nearbyPlacesJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                // TODO: - Display "Connection issues" somewhere
            }
        }
    }
    
    func parseJSON(json: JSON) {
        let status = json["status"]
        if status != "OK" {
            print("No nearby restaurants found!")
            //TODO: Display error info somewhere
        } else {
            let results = json["results"].arrayValue
            let filteredResults = results.prefix(3)
            for result in filteredResults {
                let name: String = result["name"].stringValue
                let address: String = result["formatted_address"].stringValue
                let rating: Float = result["rating"].floatValue
                let priceLevel: Int = result["price_level"].intValue
                let restaurant = restaurantInfo(name: name, address: address, rating: rating, priceLevel: priceLevel)
                
                self.restaurantList.append(restaurant)
            }
            self.locs = [
                Location(name: self.restaurantList[0].name),
                Location(name: self.restaurantList[1].name),
                Location(name: self.restaurantList[2].name)
            ]
            let tableVC = self.children.first as? TableViewController
            tableVC?.locs = locs
            dump(restaurantList)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocDetail" {
            guard let indexPath = sender as? IndexPath else { return }
            let locDetailController = segue.destination as! LocDetailController
            locDetailController.loc = locs[indexPath.row]
        }
    }
}

class TableViewController: UITableViewController {
    var locs = [Location](){
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .green
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.separatorInset = .zero
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let loc = locs[indexPath.row]
        cell.textLabel?.text = "name: \(loc.name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parent?.performSegue(withIdentifier: "toLocDetail", sender: indexPath)
    }
}

struct Location {
    let name: String
}
