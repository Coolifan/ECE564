//
//  FavouriteController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/2/18.
//  Modified by Yifan Li on 11/28/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import Firebase

class FavouriteController: UIViewController {
    var firebaseRef: DatabaseReference!
    fileprivate var restaurantPlaceIds = [String]()
    fileprivate var gardenPlaceIds = [String]()
    fileprivate var restaurants = [LocationInfo]()
    fileprivate var gardens = [LocationInfo]()
    fileprivate let downloadGroup = DispatchGroup()
    var tableView: UITableView!
    

    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.alpha = 0.85
        backgroundImage.image = UIImage(named: "favoriteBG.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        super.viewDidLoad()
        print("loading Fav")
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.fillSuperView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        view.bringSubviewToFront(tableView)
        firebaseRef = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantPlaceIds = []
        gardenPlaceIds = []
        restaurants = []
        gardens = []
        tableView.reloadData()
        getPlaces()
    }
    
    
    // MARK: - get place from API
    fileprivate func getPlaces() {
//        TODO: download list of placeIds
        restaurants = []
        gardens = []
        firebaseRef.child("favourites").child("restaurants").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: String] {
                DispatchQueue.main.async {
                    self.restaurantPlaceIds = Array(value.values)
                    self.getPlaceList(url: GoogleAPI.placeId, key: ["key" : GoogleAPI.key], placeIds: self.restaurantPlaceIds, locationType: .restaurant)
                    print(self.restaurantPlaceIds)
                }
            }
            else {
                print("No data at this path")
            }
        }) { error in
            print(error.localizedDescription)
        }
        
        firebaseRef.child("favourites").child("parks").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: String] {
                DispatchQueue.main.async {
                    self.gardenPlaceIds = Array(value.values)
                    self.getPlaceList(url: GoogleAPI.placeId, key: ["key" : GoogleAPI.key], placeIds: self.gardenPlaceIds, locationType: .garden)
                    print(self.gardenPlaceIds)
                }
            }
            else {
                print("No data at this path")
            }
        }) { error in
            print(error.localizedDescription)
        }
//        downloadGroup.enter()
        
        
//        downloadGroup.wait()
    }
    
    
    fileprivate func getPlaceList(url: String, key: [String: String], placeIds: [String], locationType: LocationAnnotation.LocationType) {
        placeIds.forEach { (placeId) in
            print(placeId, GoogleAPI.key)
            var parameters = key
            parameters["placeid"] = placeId
            Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    let PlaceJSON: JSON = JSON(response.result.value!)
                    self.parsePlaceJSON(json: PlaceJSON, locationType: locationType)
                } else {
                    print(
                        "PlaceId: \(placeId)",
                        "Failed to get location info due to a connection issue:",
                        response.result.error ?? "")
                }
            }
        }
    }
    
    fileprivate func parsePlaceJSON(json: JSON, locationType: LocationAnnotation.LocationType)  {
        if json["status"] != "OK" {
            print("Failed to parse JSON")
        } else {
                let result = json["result"]
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
                    locationType: .restaurant,
                    coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    rankValue: 0
                )
                DispatchQueue.main.async {
                    switch locationType {
                    case .restaurant: self.restaurants.append(location)
                    case .garden: self.gardens.append(location)
                    }
                    self.tableView?.reloadData()
                }
//            downloadGroup.leave()
        }
    }
}

extension FavouriteController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Restaurants" : "Parks"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? restaurants.count : gardens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LocCell(style: .default, reuseIdentifier: nil)
        let loc = indexPath.section == 0 ? restaurants[indexPath.row] : gardens[indexPath.row]
        cell.location = loc
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var location = (indexPath.section == 0) ? restaurants[indexPath.row] : gardens[indexPath.row]
        location.locationType = indexPath.section == 0 ? LocationAnnotation.LocationType.restaurant : LocationAnnotation.LocationType.garden
        performSegue(withIdentifier: "favToDetail", sender: location)
    }
}

extension FavouriteController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favToDetail" {
           let locDetailController = segue.destination as! LocDetailController
            locDetailController.location = sender as? LocationInfo
        }
    }
}
