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

//TODO: - code refactor, names change

// Struct for saving location info
struct LocationInfo {
    var name: String
    var address: String
    var imageURLParameters: [String: String]?
    var placeId: String?
    var locationType: LocationAnnotation.LocationType
    var coordinate: CLLocationCoordinate2D
}

class LocsController: UIViewController, CLLocationManagerDelegate {
    
    var locationType: String = ""
    var locationList = [LocationInfo]()
//    MARK: - GPS location manager
    let locationManager  = CLLocationManager()
//    MARK: - storyboard component
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var tableView: UIView!
    
//    MARK: - error display component
    var footerText: String? {
        didSet {
            guard let tableViewController = children.first as? TableViewController else { return }
            tableViewController.footerText = footerText
        }
    }
//    MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupTableViewController()
    }
    
    fileprivate func setupUI() {
        let mealTime = getCurrentTime()
        bannerLabel.text = "Hi Ric, it's \(mealTime) and the weather is beautiful. Here're some suggestions for you:"
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func setupTableViewController() {
        let tableViewController = TableViewController()
        tableView.addSubview(tableViewController.view)
        tableViewController.view.fillSuperView()
        addChild(tableViewController)
    }
    
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location  = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            //TODO: check what this part means
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let placesParams: [String: String] = [
                "query": locationType,
                "location": "\(latitude),\(longitude)",
                "radius": "250",
                "key": GoogleAPI.key
            ]
            getPlaceData(url: GoogleAPI.places, parameters: placesParams)
            let weatherParams: [String: String] = [
                "lat": "\(latitude)",
                "lon": "\(longitude)",
                "appid": WeatherAPI.APP_ID
            ]
            getWeatherData(url: WeatherAPI.URL, parameters: weatherParams)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location due to an error:", error)
        footerText = "Location Unavailable"
    }
    
    // MARK: - get place from API
    fileprivate func getPlaceData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let nearbyPlacesJSON: JSON = JSON(response.result.value!)
                self.parsePlacesJSON(json: nearbyPlacesJSON)
            } else {
                print("Failed to get nearby locations info due to a connection issue:", response.result.error ?? "")
                self.footerText = "Connection issues"
            }
        }
    }
    
    let locationNumber = 3
    
    fileprivate func parsePlacesJSON(json: JSON) {
        if json["status"] != "OK" {
            print("Failed to parse JSON")
            footerText = "No nearby restaurants found!"
        } else {
            let results = json["results"].arrayValue.prefix(locationNumber)
            if results.count == 0 {
                footerText = "There seems to be no \(locationType) nearby..."
                return
            }
            for result in results {
                let name: String = result["name"].stringValue
                let address: String = result["formatted_address"].stringValue
                let placeId: String = result["place_id"].stringValue
                var imageURL: [String: String]? = [
                    "maxwidth" : "400",
                    "photoreference" : "",
                ]
                if let photo = result["photos"].arrayValue.first {
                    let photoReference: String = photo["photo_reference"].stringValue
                    imageURL?["photoreference"] = photoReference
                } else {
                    imageURL = nil
                }
                let latitude = result["geometry"]["location"]["lat"].doubleValue
                let longitude = result["geometry"]["location"]["lng"].doubleValue
                let location = LocationInfo(
                    name: name,
                    address: address,
                    imageURLParameters: imageURL,
                    placeId: placeId,
                    locationType: LocationAnnotation.LocationType(rawValue:locationType.lowercased()) ?? .restuarant,
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                )
                self.locationList.append(location)
            }
            let tableVC = self.children.first as? TableViewController
            tableVC?.locationList = locationList
        }
    }
//    MARK: - get weather from API
    fileprivate func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            (response) in
            if response.result.isSuccess {
                let weatherDataJSON: JSON = JSON(response.result.value!)
                self.parseWeatherJSON(json: weatherDataJSON)
            } else {
                print("Failed to get weather info due to a connection issue:", response.result.error ?? "")
            }
        }
    }
    
    fileprivate func parseWeatherJSON(json: JSON) {
        if let tempResult = json["main"]["temp"].double { // safer
            let temperatureC: Double = Double(tempResult - 273.15)
            let city: String = json["name"].stringValue
            let description: String = json["weather"][0]["main"].stringValue.lowercased()
            let temperatureF: Int = Int(temperatureC * 1.8 + 32)
            // Display
            let mealTime = getCurrentTime()
            self.bannerLabel.text =
            """
            Hi Ric, it's \(mealTime)!
            The weather in \(city) is \(description), and the tempeture is \(temperatureF)°F.
            Here're some suggestions for you:
            """
        } else {
            print("Weather unavailable")
        }
    }
//    MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocDetail" {
            guard let indexPath = sender as? IndexPath else { return }
            let locDetailController = segue.destination as! LocDetailController
            locDetailController.location = locationList[indexPath.row]
        }
    }
}

class TableViewController: UITableViewController {
    var locationList = [LocationInfo](){
        didSet {
            tableView.reloadData()
        }
    }
    
    var footerText: String? {
        didSet {
            footerLabel.text = footerText
        }
    }
    
    let footerLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
//    MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        tableView.backgroundColor = .green
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.separatorInset = .zero
    }
//    MARK: - tableView delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LocCell(style: .default, reuseIdentifier: nil)
        let loc = locationList[indexPath.row]
        cell.location = loc
        return cell
    }
//    MARK: - segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parent?.performSegue(withIdentifier: "toLocDetail", sender: indexPath)
    }
//    MARK: - footer for error display
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = locationList.count == 0 ? 100 : 0
        return CGFloat(height)
    }
}

extension LocsController {
    enum MealTime: String {
        case breakfast = "time for breakfast", morning, lunch = "time for lunch", afternoon, dinner = "time for dinner", evening, night = "time to sleep"
    }
    
    fileprivate func getCurrentTime() -> MealTime {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var mealTime: MealTime
        switch(hour) {
        case 6...8: mealTime = .breakfast
        case 9...10: mealTime = .morning
        case 11...13: mealTime = .lunch
        case 14...16: mealTime = .afternoon
        case 17...19: mealTime = .dinner
        case 20...23: mealTime = .evening
        default: mealTime = .night
        }
        return mealTime
    }
}
