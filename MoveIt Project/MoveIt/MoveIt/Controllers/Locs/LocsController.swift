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
import Firebase

// Struct for saving location info
struct LocationInfo {
    var name: String
    var address: String
    var imageURLParameters: [String: String]?
    var placeId: String?
    var locationType: LocationAnnotation.LocationType
    var coordinate: CLLocationCoordinate2D
    var rankValue: Int // for restaurant ranking
}

struct WalkingInfo {
    var distance: String?
    var time: String?
}

class LocsController: UIViewController, CLLocationManagerDelegate {
    
    var firebaseRef: DatabaseReference!
    
    var locationType: String = ""
    var locationList = [LocationInfo]()
    var walkingInfoList = [WalkingInfo]()
    
    //    MARK: - GPS location manager
    let locationManager  = CLLocationManager()
    var myLongitude: Double?
    var myLatitude: Double?
    
    //    MARK: - storyboard component
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var tableView: UIView!
    fileprivate var backgroundImage: UIImageView!
    
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
        
        // Google Firebase reference
        firebaseRef = Database.database().reference()
        
        setupUI()
        setUIStyles()
        setupLocationManager()
        setupTableViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var components = bannerLabel.text?.components(separatedBy: ",")
        components?[0] = "Hi \(Settings.userName)"
        bannerLabel.text = components?.joined(separator: ",")
    }
    
    fileprivate func setupUI() {
        let mealTime: String = getCurrentTime()
        bannerLabel.text = "Hi Ric, it's \(mealTime) and the weather is beautiful. Here're some suggestions for you:"
        bannerLabel.font = UIFont(name: "GillSans-LightItalic", size: 18)
        bannerLabel.textColor = UIColor.black
        backgroundImage = UIImageView(frame: self.bannerLabel.bounds)
        backgroundImage.image = UIImage(named: "locbackground.png")
        backgroundImage.alpha = 0.5
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImage.frame = bannerLabel.frame
    }
    
    fileprivate func setUIStyles() {
        bannerLabel.backgroundColor = UIColor.clear
        bannerLabel.layer.opacity = 0.65
        bannerLabel.layer.cornerRadius = 50
        
        tableView.backgroundColor = UIColor.pear
        tableView.layer.opacity = 0.65
        tableView.layer.cornerRadius = 20
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
    let queryRadius: Int = 1000
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location  = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            myLatitude = latitude
            myLongitude = longitude
            
            let placesParams: [String: String] = [
                "query": locationType,
                "location": "\(latitude),\(longitude)",
                "radius": "\(queryRadius)",
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
    
    let selectNumber = 10
    
    fileprivate func parsePlacesJSON(json: JSON) {
        if json["status"] != "OK" {
            print("Failed to parse JSON")
            footerText = "No nearby restaurants found!"
        } else {
            let results = json["results"].arrayValue
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
            
                print(locationType.lowercased())
                let location = LocationInfo(
                    name: name,
                    address: address,
                    imageURLParameters: imageURL,
                    placeId: placeId,
                    locationType: LocationAnnotation.LocationType(rawValue:locationType.lowercased()) ?? .restaurant,
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    rankValue: restaurantRanking.getRankValue(name)
                )
                self.locationList.append(location)
            }
            
            self.locationList = Array((locationList.sorted {
                $0.rankValue > $1.rankValue
            }).prefix(selectNumber))
            
            let tableVC = self.children.first as? TableViewController
            tableVC?.locationList = locationList
            
            for _ in 0..<selectNumber {
                walkingInfoList.append(WalkingInfo())
            }
            
            getDistances()
        }
    }
    
    fileprivate func getDistances() {
        for (index, locationInfo) in locationList.enumerated() {
            getDistance(
                index: index,
                targetLatitude: locationInfo.coordinate.latitude,
                targetLongitude: locationInfo.coordinate.longitude
            )
        }
    }
    
    fileprivate func getDistance(index: Int, targetLatitude: Double, targetLongitude: Double) {
        let parameters = [
            "units": "imperial",
            "origins": "\(myLatitude!),\(myLongitude!)",
            "destinations": "\(targetLatitude),\(targetLongitude)",
            "mode": "walking",
            "key": DistanceMatrixAPI.key
        ]
        Alamofire.request(DistanceMatrixAPI.url, method: .get, parameters: parameters).responseJSON {
            (response) in
            if response.result.isSuccess {
                let walkingDataJSON: JSON = JSON(response.result.value!)
                let row = walkingDataJSON["rows"].arrayValue[0]
                let element = row["elements"].arrayValue[0]
                let distance = element["distance"]["text"].stringValue
                let duration = element["duration"]["text"].stringValue
                self.walkingInfoList[index].distance = distance
                self.walkingInfoList[index].time = duration
                
                let tableVC = self.children.first as? TableViewController
                DispatchQueue.main.async {
                    tableVC?.walkingInfoList = self.walkingInfoList
                }
            } else {
                print("Failed to get distance info due to a connection issue:", response.result.error ?? "")
            }
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
            
            let mealTime: String = getCurrentTime()
            self.bannerLabel.text =
            """
            Hi \(Settings.userName), it's \(mealTime)!
            The weather in \(city) is \(description), and the tempeture is \(temperatureF)°F.
            Here're some recommendations for you:
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
    
    var walkingInfoList = [WalkingInfo]() {
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
        tableView.backgroundColor = .backgroundWhite
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
        if walkingInfoList.count == locationList.count {
            let walkingInfo = walkingInfoList[indexPath.row]
            if let distance = walkingInfo.distance,
                let time = walkingInfo.time {
                cell.descriptionLabel.text = "\(time) walk, (\(distance))"
            } else {
                cell.descriptionLabel.text = "distance info unavailable"
            }
        }
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
    fileprivate func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var mealTime: String
        switch(hour) {
        case 6...8: mealTime = "time for breakfast"
        case 9...10: mealTime = "morning"
        case 11...13: mealTime = "time for lunch"
        case 14...16: mealTime = "afternoon"
        case 17...19: mealTime = "time for dinner"
        default: mealTime = "evening"
        }
        return mealTime
    }
}
