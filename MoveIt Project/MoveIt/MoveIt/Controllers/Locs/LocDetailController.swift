//
//  LocDetailController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/3/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Contacts

class LocDetailController: UIViewController {
//    MARK: - data source
    var location: LocationInfo?
//    MARK: - annotation
    var annotation: LocationAnnotation?
//    MARK: - locationManager
    let locationManager = CLLocationManager()
    //    MARK: - UI component: mainStackView and bannerImage component
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var bannerImageView: UIImageView!
    //    MARK: - UI component: name component
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var nameTag: UILabel!
    @IBOutlet weak var name: UILabel!
    //    MARK: - UI component: address component
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var addressTag: UILabel!
    @IBOutlet weak var address: UILabel!
    //    MARK: - UI component: phone component
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var phoneTag: UILabel!
    @IBOutlet weak var phone: UILabel!
    //    MARK: - UI component: website component
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var websiteTag: UILabel!
    @IBOutlet weak var website: UILabel!
    //    MARK: - UI component: map and goMapApp button component
    @IBOutlet weak var mapView: MKMapView!
    let goMapAppButton: GoMapAppButton = {
        let button = GoMapAppButton()
        return button
    }()
    
    //    MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillContent()
        checkLocationServices()
        setupMap()
    }
    
//    MARK: - setup UI
    fileprivate func setupUI() {
        setupMainStackView()
        setupBannerImageView()
        setupLabels()
    }
    
    fileprivate func setupGoMapAppButton() {
        mainStackView.addArrangedSubview(goMapAppButton)
        goMapAppButton.translatesAutoresizingMaskIntoConstraints = false
        goMapAppButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    fileprivate func setupMainStackView() {
        setupGoMapAppButton()
        mainStackView.spacing = 8
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 15, right: 5))
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    fileprivate func setupBannerImageView() {
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
    }
    
    fileprivate func setupLabels() {
        setupTagLabels()
        setupContentLabels()
        setupLabelStackViews()
    }
    
    fileprivate func setupTagLabels() {
        nameTag.text = "name"
        addressTag.text = "address"
        phoneTag.text = "phone"
        websiteTag.text = "website"
        let tags = [nameTag, addressTag, phoneTag, websiteTag]
        tags.forEach { (tag) in
            tag?.translatesAutoresizingMaskIntoConstraints = false
            tag?.widthAnchor.constraint(equalToConstant: 55).isActive = true
            tag?.font = UIFont.boldSystemFont(ofSize: 12)
            tag?.backgroundColor = .yellow
            tag?.text?.append(":")
            tag?.textAlignment = .right
        }
    }
    
    fileprivate func setupContentLabels() {
        let contentLabels = [name, address, phone, website]
        contentLabels.forEach { (contentLabel) in
            contentLabel?.font = UIFont.systemFont(ofSize: 10)
            contentLabel?.lineBreakMode = .byWordWrapping
            contentLabel?.numberOfLines = 0
        }
    }
    
    fileprivate func setupLabelStackViews() {
        let stackViews = [nameStackView, addressStackView, phoneStackView, websiteStackView]
        stackViews.forEach { (stackView) in
            stackView?.spacing = 6
            stackView?.alignment = .top
        }
    }
//    MARK: - fill content
    fileprivate func fillContent() {
        guard let location = location else { return }
        setAddressInfo(name: location.name, address: location.address)
        //get & set contact info
        let parameters = [
            "placeid": location.placeId ?? "",
            "fields": "formatted_phone_number,website",
            "key": GoogleAPI.key
        ]
        getPlaceData(url: GoogleAPI.placeDetail, parameters: parameters)
        //get & set banner photo
        guard let imageURLParameters = location.imageURLParameters else { return }
        downloadPhoto(using: imageURLParameters)
    }
    
    fileprivate func setAddressInfo(name: String, address: String) {
        self.name.text = name
        self.address.text = address
    }
    
    // MARK: - get contact info
    fileprivate func getPlaceData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let placeDetailJSON: JSON = JSON(response.result.value!)
                self.parseJSON(json: placeDetailJSON)
            } else {
                print("Failed to get detail location info due to a connection issue:", response.result.error ?? "")
            }
        }
    }
    
    fileprivate func parseJSON(json: JSON) {
        if json["status"] != "OK" {
            print("Failed to parse JSON")
        } else {
            let result = json["result"].dictionaryValue
            let phone: String = result["formatted_phone_number"]?.stringValue ?? "no phone available"
            let website: String = result["website"]?.stringValue ?? "no website available"
            setContactInfo(phone: phone, website: website)
            setContactInfoForAnnotation(phone: phone, website: website)
        }
    }
    
    fileprivate func setContactInfo(phone: String, website: String) {
        self.phone.text = phone
        self.website.text = website
    }
    
    fileprivate func setContactInfoForAnnotation(phone: String, website: String) {
        annotation?.website = website
        annotation?.phone = phone
    }
    
    //    MARK: - photo download
    fileprivate func downloadPhoto(using urlParameters: [String: String]) {
        guard let urlString = generateImageURLString(using: urlParameters) else { return }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to download location image<##>", err)
                return
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.bannerImageView.image = image
            }
            }.resume()
    }
    
    let maxWidth = 800
    
    private func generateImageURLString(using parameters: [String: String]) -> String? {
        guard let photoReference = parameters["photoreference"] else { return nil }
        return "\(GoogleAPI.image)?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(GoogleAPI.key)"
    }
    
//    MARK: - setup location manager
    fileprivate func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
//            TODO: - show an alert to inform the user to turn on location service in setttings
            print("Location Service unavailable")
        }
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    fileprivate func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
//            TODO: - show an alert tell the user what to do
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
//            TODO: - show an alert tell the user what's up
            break
        case .authorizedAlways:
//            TODO: - This is not what we expect
            break
        }
    }
    
    let regionSideLength: Double = 3000 // in meters
    
    fileprivate func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionSideLength, longitudinalMeters: regionSideLength)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //    MARK: - setup mapView
    fileprivate func setupMap() {
        mapView.delegate = self
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        addAnnotation()
    }
    
    fileprivate func addAnnotation() {
        guard let location = location else { return }
        annotation = LocationAnnotation(
            locationType: location.locationType,
            coordinate: location.coordinate,
            address: location.address,
            title: location.name
        )
        guard let annotation = annotation else { return }
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
}


extension LocDetailController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionSideLength, longitudinalMeters: regionSideLength)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension LocDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LocationAnnotation else { return nil }
        let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        var view: MKAnnotationView
        if let dequeuedView =  mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? AnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.annotation = annotation
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? LocationAnnotation else { return }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        annotation.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

class LocationAnnotation: NSObject, MKAnnotation {
    var locationType: LocationType
    var coordinate: CLLocationCoordinate2D
    var address: String
    var title: String?
    var subtitle: String?
    var phone: String?
    var website: String?
    
    enum LocationType: String {
        case garden
        case restuarant
    }
    
    init(locationType: LocationType, coordinate: CLLocationCoordinate2D, address: String, title: String, subtitle: String? = nil, phone: String? = nil, website: String? = nil) {
        self.locationType = locationType
        self.coordinate = coordinate
        self.address = address
        self.title = title
        self.subtitle = subtitle
        self.phone = phone
        self.website = website
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressComponents = address.components(separatedBy: ",")
        let addressDictionary = [
            CNPostalAddressStreetKey: addressComponents.first ?? ""
        ]
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as [String: Any])
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = title
        mapItem.phoneNumber = phone
        mapItem.url = URL(string: website ?? "")
        return mapItem
    }
}
